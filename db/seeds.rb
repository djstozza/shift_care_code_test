# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

3.times do |i|
  Admin.create!(
    first_name: "Admin #{i}",
    last_name: "User #{i}",
    email: "admin#{i}@example.com",
    password: ENV['DEFAULT_PASSWORD']
  )
end

30.times do |i|
  client = Client.new(
    first_name: "Client #{i}",
    last_name: "User #{i}",
    email: "client2#{i}@example.com",
    private_note: "Lorem ipsum dolor sit amet #{i}",
    date_of_birth: Date.new(2000 - i, i % 12 + 1, 10),
    address_attributes: {
      address_line_1: "#{i} Oxford St",
      suburb: 'Bondi Junction',
      state: 'NSW',
      post_code: '2022',
      country: 'AUS',
    }
  )

  client.save!

  start_time = rand(100).hours.from_now.beginning_of_hour
  end_time = start_time + rand(1..5).hours

  job = Job.new(
    client: client,
    start_time: start_time,
    end_time: end_time
  )
  job.save!

  rand(1..4).times do |j|
    plumber = Plumber.new(
      first_name: "Plumber #{i} #{j}",
      last_name: "User #{i} #{j}",
      email: "plumber#{i}@example#{j}.com",
      address_attributes: {
        address_line_1: "#{i} #{j} Military Rd",
        suburb: 'Mosman',
        state: 'NSW',
        post_code: '2088',
        country: 'AUS',
      }
    )

    plumber.save!

    job.plumbers << plumber

    2.times do |k|
      plumber.vehicles << Vehicle.create(
        make: Vehicle.makes.keys[rand(0..5)],
        model: "Model #{i} #{j} #{k}",
        year: Vehicle::MINIMUM_YEAR + i % (Date.current.year - Vehicle::MINIMUM_YEAR),
        number_plate: "abc#{i} #{j} #{k}"
      )
    end
  end
end
