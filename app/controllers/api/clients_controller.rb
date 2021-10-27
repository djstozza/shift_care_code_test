class Api::ClientsController < Api::BaseController
  before_action :authenticate_admin!

  load_resource :client, only: %i[update]

  def index
    respond_with ClientSerializer.map(Client.all)
  end

  def create
    service = Clients::Process.call(client_params)

    respond_with service.errors.any? ? service : serialized_client(service.client)
  end

  def update
    service = Clients::Process.call(client_params, client: client)

    respond_with service.errors.any? ? service : serialized_client(service.client)
  end

  private

  def client_params
    params.require(:client).permit(
      :first_name,
      :last_name,
      :date_of_birth,
      :email,
      :private_note,
      :address_line_1,
      :address_line_2,
      :suburb,
      :state,
      :post_code,
      :country
    )
  end

  def client
    Client.find(params[:id])
  end

  def serialized_client(client)
    ClientSerializer.new(client, address: true, private_note: true)
  end
end
