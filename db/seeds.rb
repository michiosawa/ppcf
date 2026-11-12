# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

User.destroy_all
user = User.create!(
  username: "admin",
  email: "test@home",
  password: "1321522",
  password_confirmation: "1321522",
)

Company.destroy_all
company = Company.create!(
  name: "個人",
  owner: "個人",
)

search = Company.where(name:"個人").pluck(:id)
kaisha = Company.find_by(id: search)

Worker.destroy_all
worker = Worker.create!(
  name: "michio",
  company: kaisha,
)

Workplace.destroy_all
workplace = Workplace.create!(
  title: "本社",
  address: "横浜市鶴見区鶴見中央2-14-22"
)

puts User.find_by(username: "admin").username
puts Company.find_by(name: "個人").name
puts Worker.find_by(name: "michio").name
puts Workplace.find_by(title: "本社").title
