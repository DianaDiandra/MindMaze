# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'httparty'
require "json"
require "open-uri"

puts "Clearing old data..."
Performance.destroy_all
Target.destroy_all
Game.destroy_all
Goal.destroy_all
User.destroy_all

# Create users
users_data = [
  {
    username: "diana_di",
    email: "diana.culita100@gmail.com",
    password: "password",
    first_name: "Diana",
    last_name: "Culita",
    age: 26,
    avatar_url: "https://res.cloudinary.com/dkb0r20o0/image/upload/c_thumb,w_200,g_face/v1747939607/mnljzu26h8hj59ovkzhl.jpg"
  },
  {
    username: "manel_bh",
    email: "mani@example.com",
    password: "password",
    first_name: "Manel",
    last_name: "M",
    age: 26,
    avatar_url: "https://res.cloudinary.com/dtyuldook/image/upload/v1748518833/78561237_p3hhnq.jpg"
  },
  {
    username: "luke_b",
    email: "Luke@example.com",
    password: "password",
    first_name: "Luke",
    last_name: "Burton",
    age: 26,
    avatar_url: "https://res.cloudinary.com/dtyuldook/image/upload/v1748433459/development/s8u294a9t2c6qzl6q9i8rhc5zlpj.jpg"
  },
  {
    username: "Teagan_d",
    email: "Teagan@example.com",
    password: "password",
    first_name: "Teagan",
    last_name: "Dorsch",
    age: 26,
    avatar_url: "https://res.cloudinary.com/dtyuldook/image/upload/v1748518879/204461253_pjl20k.jpg"
  }
]

users = users_data.map do |data|
  puts "Creating user: #{data[:username]}"
  file = URI.parse(data[:avatar_url]).open
  user = User.new(data.except(:avatar_url))
  user.avatar.attach(io: file, filename: "#{data[:username]}.jpg", content_type: "image/jpg")
  user.save!
  puts "Done"
  user
end

# Create goals
puts "Creating goals..."
goals = [
  Goal.create!(name: "Reasoning"),
  Goal.create!(name: "Time Reaction"),
  Goal.create!(name: "Logic")
]
puts "Created #{goals.size} goals"

# Create basic games
puts "Creating basic games..."
games = [
  Game.create!(
    mode: "single player",
    name: "2048",
    category: "Reasoning",
    description: "2048 game description...",
    embed_link: "/games/2048/index.html",
    image_url: "https://res.cloudinary.com/dtyuldook/image/upload/v1748864553/2048_logo_v8gakh.svg",
    goal: goals[0]
  ),
  Game.create!(
    mode: "single player",
    name: "Hextris",
    category: "Time Reaction",
    description: "Hextris game description...",
    embed_link: "/games/hextris/index.html",
    image_url: "https://res.cloudinary.com/dtyuldook/image/upload/v1748864662/0jCMd4dIANQ9QD3Q1r0y7-ZnpVb74dMHHtsz9-qPFDSRHRVvg-Q3ENsaCOabUsvsz7Q_o3tprc.png",
    goal: goals[1]
  ),
  Game.create!(
    mode: "Single player",
    name: "ohh1",
    category: "Logic",
    description: "Oh h1 game description...",
    embed_link: "/games/ohh1/index.html",
    image_url: "https://res.cloudinary.com/dtyuldook/image/upload/v1748864737/LYnyOCfAUobaPRm262hjhvNg9eE14sPj5H6CFiUxjktt7R0QZX5kLbE7LDEgxm6brwg_ci1jbn.png",
    goal: goals[2]
  )
]


begin
  puts "Fetching Cognifit games..."
  response = HTTParty.get("https://api.cognifit.com/programs/tasks", query: {
    client_id: ENV['COGNIFIT_CLIENT_ID'],
    locales: ['en'],
    category: 'COGNITIVE'
  })

  if response.success?
    cognifit_games = response.parsed_response.first(20).map do |game_data|
      Game.create!(
        mode: "Single player",
        name: game_data.dig("assets", "titles", "en") || game_data["key"],
        category: "Cognitive",
        description: game_data.dig("assets", "descriptions", "en") || "CogniFit Game",
        embed_link: game_data["key"],
        image_url: game_data.dig("assets", "images", "icon") || "",
        goal: goals.sample
      )
    end
    games += cognifit_games
    puts "Seeded #{cognifit_games.size} Cognifit games."
  end
rescue => e
  puts " Failed to fetch Cognifit games: #{e.message}"
end

puts "Total games: #{Game.count}"

# Create targets
puts "Creating targets..."
targets = users.flat_map do |user|
  goals.map do |goal|
    Target.create!(
      user: user,
      goal: goal,
      sleep: rand(6..9)
    )
  end
end
puts "Created #{targets.size} targets"

sample_descriptions = [
  "Heard eating spinach helps with focus, I’ll also try to sleep more.",
  "Really fun logic puzzle. I’m getting faster!",
  "Kept getting distracted, will try again later.",
  "Loved the color scheme, not sure about the strategy yet.",
  "Scored better today, might be the coffee",
  "Tried a new method, kind of worked. Needs tweaking.",
  "This was surprisingly difficult but satisfying.",
  "Beat my old score! So proud."
]

puts "Creating 8 performances for each user..."

User.find_each do |user|
  user_targets = Target.where(user: user)

  8.times do
    Performance.create!(
      target: user_targets.sample,
      game: Game.all.sample,
      description: sample_descriptions.sample,
      accuracy: rand(50..100).round(2),
      score: rand(300..850),
      last_score: rand(250..850),
      final_score: rand(250..850),
      time: rand(20.0..120.0).round(1),
      completed: true,
      created_at: rand(1..6).days.ago,
      updated_at: Time.now
    )
  end

  puts "Seeded 8 performances for #{user.username}"
end

puts "All performances seeded!"
