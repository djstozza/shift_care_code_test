class Api::PlumbersController < Api::BaseController
  before_action :authenticate_admin!

  load_resource :plumber, only: %i[update]

  def index
    respond_with PlumberSerializer.map(Plumber.all)
  end

  def create
    service = Plumbers::Process.call(plumber_params)

    respond_with service.errors.any? ? service : serialized_plumber(service.plumber)
  end

  def update
    service = Plumbers::Process.call(plumber_params, plumber: plumber)

    respond_with service.errors.any? ? service : serialized_plumber(service.plumber)
  end

  private

  def plumber_params
    params.require(:plumber).permit(
      :first_name,
      :last_name,
      :email,
      :address_line_1,
      :address_line_2,
      :suburb,
      :state,
      :post_code,
      :country
    )
  end

  def plumber
    Plumber.find(params[:id])
  end

  def serialized_plumber(plumber)
    PlumberSerializer.new(plumber, address: true, private_note: true)
  end
end
