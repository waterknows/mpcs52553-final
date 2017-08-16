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
example = User.create name: 'admin', email: 'admin@example.com', password: 'admin'

# Load 'reviews' table from csv. 
# Attribution: https://gist.github.com/arjunvenkat/1115bc41bf395a162084

Review.delete_all

csv_text = File.read(Rails.root.join('lib', 'seeds', 'abstracts_mini.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'UTF-8')
csv.each do |row|
  t = Review.new
  t.description = row['description']
  t.name = row['name']
  t.user_id = example.id

  t.save
end

puts "#{User.count} users."
puts "#{Review.count} reviews."