# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "seedの実行を開始"

Admin.find_or_create_by!(email: ENV['SECRET_EMAIL']) do |admin|
  admin.password = ENV['SECRET_PASSWORD']
end

arnold = User.find_or_create_by!(email: ENV['TEST_EMAIL1']) do |user|
  user.name = "Arnold"
  user.password = ENV['TEST_PASSWORD']
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user1.jpg"), filename:"sample-user1.jpg")
end

stallone = User.find_or_create_by!(email: ENV['TEST_EMAIL2']) do |user|
  user.name = "Stallone"
  user.password = ENV['TEST_PASSWORD']
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user2.jpg"), filename:"sample-user2.jpg")
end

dolph = User.find_or_create_by!(email: ENV['TEST_EMAIL3']) do |user|
  user.name = "Dolph"
  user.password = ENV['TEST_PASSWORD']
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user3.jpg"), filename:"sample-user3.jpg")
end


puts "seedの実行が完了しました"