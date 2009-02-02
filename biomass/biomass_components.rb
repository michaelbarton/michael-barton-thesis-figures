require 'hpricot'

doc = Hpricot::XML(File.open('iND750.xml'))
biomass_reactants = doc.search("//reaction[@id='R_biomass_SC4_bal']/listOfReactants/speciesReference")

requirements = biomass_reactants.inject(Hash.new) do |hash,reactant|

  species_name = doc.at("//species[@id='#{reactant['species']}']")['name']
  species_name = species_name.split('_')[1..-2] * '_'

  species_name.gsub!('__yeast_specific','')
  species_name.gsub!('L_','')

  species_name.gsub!('_',' ')

  requirement = reactant['stoichiometry'].to_f

  hash.store(species_name,requirement)
  hash
end



requirements.keys.sort.each do |name|
  printf("%-30s , %8.5f\n",name,requirements[name])
end
