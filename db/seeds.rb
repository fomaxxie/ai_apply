require "faker"

puts 'Destroying database ...'
User.destroy_all
Profile.destroy_all

puts 'Creating 20 fake users ...'

20.times do
  user = User.new(
    email: Faker::Internet.email,
    password: "123456",
  )
  user.save!
end

puts 'Creating 10 fake profiles with 10 random Users as Owners...'

10.times do
  next unless User.any?

  profile = Profile.new(
    full_name: Faker::Name.name,
    desired_position: Faker::Job.title,
    years_of_experience: rand(0..20),
    technical_skills: Faker::Job.key_skill,
    soft_skills: Faker::Job.key_skill,
    details: Faker::Lorem.paragraph,
    phone_number: Faker::PhoneNumber.phone_number,
    location: Faker::Address.city,
    email: Faker::Internet.email,
    website: Faker::Internet.url,
    linkedin: Faker::Internet.url,
    twitter: Faker::Internet.url,
    instagram: Faker::Internet.url,
    github: Faker::Internet.url,
    user_id: User.all.sample.id
  )
  profile.save!
end
