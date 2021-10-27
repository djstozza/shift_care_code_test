# == Schema Information
#
# Table name: plumbers
#
#  id         :bigint           not null, primary key
#  email      :citext           not null
#  first_name :citext           not null
#  last_name  :citext           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_plumbers_on_email  (email) UNIQUE
#

class Plumber < ApplicationRecord
  has_paper_trail

  has_one :address, as: :addressable, dependent: :destroy
  has_many :vehicles
  has_and_belongs_to_many :jobs

  validates :address, presence: true
  validates :email, :first_name, :last_name, presence: true
  validates :email, uniqueness: true, allow_blank: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
