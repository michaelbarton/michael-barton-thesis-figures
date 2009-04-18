require 'set'
require 'rubygems'
require 'hpricot'
require 'fastercsv'

optimal = Set.new
suboptimal = Set.new

FasterCSV.open('data/gene_constraint.csv', :headers => true).each do |row|
  if row['type'] == "variable"
    if row['setup'] == "optimal"
      optimal.add(row['gene'])
    else
      suboptimal.add(row['gene'])
    end
  end
end

both = optimal & suboptimal
optimal = optimal - both
suboptimal = suboptimal - both

doc = Hpricot::XML(File.open('data/iND750.xml'))

registry = (doc/"//reaction/notes").inject(Hash.new) do |hash,reaction|
  gene, protein, system = nil
  reaction.containers.each do |note|
    key, value = note.inner_html.split(': ')
    gene = value    if key == "GENE_ASSOCIATION"
    protein = value if key == "PROTEIN_ASSOCIATION"
    system = value  if key == "SUBSYSTEM"
  end
  hash.store(gene,[system,protein])
  hash
end

FasterCSV.open('results/gene_descriptions.csv', 'w') do |csv|
  csv << %w|solution gene protein system|
  both.each {|gene| csv << %W|both #{gene} #{registry[gene].last} #{registry[gene].first}| }
  optimal.each {|gene| csv << %W|optimal #{gene} #{registry[gene].last} #{registry[gene].first}| }
  suboptimal.each {|gene| csv << %W|suboptimal #{gene} #{registry[gene].last} #{registry[gene].first}| }
end
