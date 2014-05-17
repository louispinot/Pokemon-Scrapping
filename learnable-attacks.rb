require 'nokogiri'
require 'pp'
require 'open-uri'
require 'CSV'
require 'pry'

### Excludes Mr. Mime, Male and Female Nidoran. Deal with them separately
pokemon =[]
CSV.foreach("./pokemon-list.csv") do |line|
  pokemon << line[0].to_s
  end


def parse_levelup_attacks(pokemon)

        url = "http://bulbapedia.bulbagarden.net/wiki/" + pokemon + "_(Pok%C3%A9mon)/Generation_I_learnset#By_leveling_up"
        html = open(url)
        doc = Nokogiri::HTML(html)

        parsed_table = []
        doc.search(".sortable").each do |table|
          table.search("td").each do |row|
            row = row.inner_text.strip
            parsed_table << row
          end
        end

        attacks_for_this_pokemon =[]
        parsed_table.each_index do |i|
          if i % 6 == 0
            parsed_table[i] = parsed_table[i][0..1]
            attacks_for_this_pokemon << parsed_table[i]
          end
          if i % 6 == 1
            attacks_for_this_pokemon << parsed_table[i]
          end
        end

        attacks_for_this_pokemon = attacks_for_this_pokemon.each_slice(2).to_a
        attacks_for_this_pokemon.each do |attack|
          attack = attack.insert(0, pokemon)
          #attack = attack.join(",")
        end

        File.open('./attack-ref-file', "a") do |file|
          attacks_for_this_pokemon.each do |attack|
            attack = attack.join(",") + "\n"
            file.write(attack)
          end
        end
end


pokemon.each do |pokemon_name|
  parse_levelup_attacks(pokemon_name)
end
