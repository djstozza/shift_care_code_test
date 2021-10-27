class Plumbers::Process < ApplicationService
  attr_reader :plumber,
              :first_name,
              :last_name,
              :email,
              :address_line_1,
              :address_line_2,
              :suburb,
              :state,
              :post_code,
              :country

  validates :first_name,
            :last_name,
            :email,
            :address_line_1,
            :suburb,
            :state,
            :post_code,
            :country,
            presence: true

  validate :valid_plumber

  def initialize(data, plumber: nil)
    @plumber = plumber || Plumber.new
    @first_name = data[:first_name]
    @last_name = data[:last_name]
    @email = data[:email]

    @address_line_1 = data[:address_line_1]
    @address_line_2 = data[:address_line_2]
    @suburb = data[:suburb]
    @state = data[:state]
    @post_code = data[:post_code]
    @country = data[:country]
  end

  def call
    valid?
  end

  private

  def valid_plumber
    plumber.update(
      first_name: first_name,
      last_name: last_name,
      email: email,
      address_attributes: {
        address_line_1: address_line_1,
        address_line_2: address_line_2,
        suburb: suburb,
        state: state,
        post_code: post_code,
        country: country,
      }
    )
  end
end
