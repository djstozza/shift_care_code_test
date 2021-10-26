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

class Client < ApplicationRecord
  include ActionView::Helpers::DateHelper
  validates :email, :first_name, :last_name, :date_of_birth, presence: true
  validates :email, uniqueness: true, allow_blank: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  def age
    ((Time.current - date_of_birth.to_time) / 1.year.seconds).floor
  end
end