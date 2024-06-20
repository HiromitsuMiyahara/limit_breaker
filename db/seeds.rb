# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "seedの実行を開始"

  Admin = User.find_or_create_by!(email: ENV['SECRET_EMAIL']) do |admin|
    admin.name = "管理者"
    admin.password = ENV['SECRET_PASSWORD']
   end

puts "seedの実行が完了しました"