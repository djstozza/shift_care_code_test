# == Schema Information
#
# Table name: plumbers
#
#  id         :bigint           not null, primary key
#  email      :citext           not null
#  name       :citext           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_plumbers_on_email  (email) UNIQUE
#

FactoryBot.define do
  factory :plumber do
    sequence :first_name do |n|
      "Pumber First Name #{n}"
    end

    sequence :last_name do |n|
      "Plumber Last Name #{n}"
    end

    sequence :email do |n|
      "plumber#{n}@example.com"
    end

    before(:create) do |plumber|
      plumber.address ||= create(:address, addressable: plumber)
    end
  end
end
