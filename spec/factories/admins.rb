# == Schema Information
#
# Table name: admins
#
#  id                     :bigint           not null, primary key
#  current_sign_in_at     :datetime
#  email                  :citext           not null
#  encrypted_password     :string           not null
#  first_name             :citext           not null
#  last_name              :citext           not null
#  last_sign_in_at        :datetime
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_admins_on_email                 (email) UNIQUE
#  index_admins_on_reset_password_token  (reset_password_token) UNIQUE
#

FactoryBot.define do
  factory :admin do
    sequence :first_name do |n|
      "First Name #{n}"
    end

    sequence :last_name do |n|
      "Last Name #{n}"
    end

    sequence :email do |n|
      "admin#{n}@example.com"
    end

    password { 'password' }
  end
end
