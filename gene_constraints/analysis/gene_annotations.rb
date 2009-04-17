require 'set'
require 'rubygems'
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

registry = File.open('data/registry.genenames.tab').inject(Hash.new) do |hash,row|
  values = row.split("\t")
  hash.store(values[-2],values[2].split(';').first)
  hash
end

FasterCSV.open('results/gene_descriptions.csv', 'w') do |csv|
  csv << %w|solution gene description|
  both.each {|gene| csv << %W|both #{gene} #{registry[gene]}| }
  optimal.each {|gene| csv << %W|optimal #{gene} #{registry[gene]}| }
  suboptimal.each {|gene| csv << %W|suboptimal #{gene} #{registry[gene]}| }
end
