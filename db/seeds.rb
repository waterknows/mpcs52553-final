# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

# Reset the 'users' table
User.delete_all
microsoft = User.create name: 'microsoft', email: 'admin@microsoft.com', privilege: 'admin', password: 'admin'
worldbank = User.create name: 'worldbank', email: 'admin@worldbank.org', privilege: 'admin', password: 'admin'

# Load 'documents' table from csv. 
# Attribution: https://gist.github.com/arjunvenkat/1115bc41bf395a162084

Document.delete_all

csv_text = File.read(Rails.root.join('lib', 'seeds', 'abstracts_mini.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'UTF-8')
csv.first(10).each do |row|
  t = Document.new
  t.description = row['description']
  t.name = row['name']
  t.user_id = microsoft.id

  t.save
end

Tag.delete_all


puts "#{User.count} users."
puts "#{Document.count} documents."
puts "#{Tag.count} tags."