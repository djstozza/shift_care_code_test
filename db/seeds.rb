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
    email: "admin3#{i}@example.com",
    password: ENV['DEFAULT_PASSWORD']
  )
end


5.times do |i|
  Client.create!(
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
end

10.times do |i|
  plumber = Plumber.new(
    first_name: "Plumber #{i}",
    last_name: "User #{i}",
    email: "plumber1#{i}@example.com",
    address_attributes: {
      address_line_1: "#{i} Military Rd",
      suburb: 'Mosman',
      state: 'NSW',
      post_code: '2088',
      country: 'AUS',
    }
  )

  plumber.save!

  2.times do |j|
    plumber.vehicles << Vehicle.create(
      make: Vehicle.makes.keys[rand(0..5)],
      model: "Model #{i}",
      year: Vehicle::MINIMUM_YEAR + i % (Date.current.year - Vehicle::MINIMUM_YEAR),
      number_plate: "abc#{i}#{j}"
    )
  end
end


Job.create(
  client: Client.first,
  plumbers: [Plumber.second, Plumber.fifth],
  start_time: 10.hours.from_now,
  end_time: 13.hours.from_now
)

Job.create(
  client: Client.fourth,
  plumbers: [Plumber.first],
  start_time: 1.hour.ago,
  end_time: 4.hours.from_now
)

Job.create(
  client: Client.last,
  plumbers: [Plumber.third, Plumber.fourth],
  start_time: 2.hours.from_now,
  end_time: 5.hours.from_now
)

Job.create(
  client: Client.third,
  plumbers: [Plumber.last],
  start_time: 4.hours.from_now,
  end_time: 7.hours.from_now
)

Job.create(
  client: Client.fifth,
  plumbers: [Plumber.second],
  start_time: 2.hours.from_now,
  end_time: 6.hours.from_now
)
