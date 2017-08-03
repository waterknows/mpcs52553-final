# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# Reset the 'users' table
User.delete_all
doctor723 = User.create name: 'doctor723', email: 'doctor723@example.com', password: 'xiaoxiao'
example = User.create name: 'example', email: 'examplet@example.com', password: 'xiaoxiao'

# Reset the 'reviews' table
Review.delete_all
a = Review.create user_id: doctor723.id, name: 'Positive review', description: 'This is the worst movie I have ever seen!'
b = Review.create user_id: doctor723.id, name: 'Negative review', description: 'This is the best movie I have ever seen!'

puts "#{User.count} users."
puts "#{Review.count} reviews."