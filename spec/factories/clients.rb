# == Schema Information
#
# Table name: clients
#
#  id            :bigint           not null, primary key
#  date_of_birth :date             not null
#  email         :citext           not null
#  first_name    :citext           not null
#  last_name     :citext           not null
#  private_note  :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_clients_on_email  (email) UNIQUE
#

FactoryBot.define do
  factory :client do
    sequence :first_name do |n|
      "First Name #{n}"
    end

    sequence :last_name do |n|
      "Last Name #{n}"
    end

    sequence :email do |n|
      "client#{n}@example.com"
    end

    date_of_birth { '17/08/1988' }
  end
end
