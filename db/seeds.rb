# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# add data to micropost table
def create_seed_micropost_data
  10.times do |i|
    i += 1
    Micropost.create(title: "title #{i}", content: "This is content #{i}")
  end
end

def create_seed_users_data
  10.times do |i|
    i += 1
    User.create(name: "users #{i}", birthday: "10/11/2000", admin: "#{(i % 2).zero? ? true : false}")
  end
end

def create_seed_microposts_data
  10.times do |i|
    i += 1
    Micropost.create(:content => "This is post #{i + 1}", :user_id => 1)
  end
end

create_seed_microposts_data
# create_seed_users_data
# create_seed_micropost_data
