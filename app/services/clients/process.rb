class Clients::Process < ApplicationService
  attr_reader :client,
              :first_name,
              :last_name,
              :email,
              :date_of_birth,
              :private_note,
              :address_line_1,
              :address_line_2,
              :suburb,
              :state,
              :post_code,
              :country

  validates :first_name,
            :last_name,
            :email,
            :date_of_birth,
            :address_line_1,
            :suburb,
            :state,
            :post_code,
            :country,
            presence: true

  validate :valid_client

  def initialize(data, client: nil)
    @client = client || Client.new
    @first_name = data[:first_name]
    @last_name = data[:last_name]
    @email = data[:email]
    @date_of_birth = data[:date_of_birth]
    @private_note = data[:private_note]

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

  def valid_client
    client.update(
      first_name: first_name,
      last_name: last_name,
      email: email,
      date_of_birth: date_of_birth,
      private_note: private_note,
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
