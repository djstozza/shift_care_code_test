class Api::SessionsController < Api::BaseController
  before_action :authenticate_admin!, only: [:update]

  def create
    admin = Admin.find_by(email: sign_in_params[:email])
    service = Admins::SignIn.call(sign_in_params, admin: admin)
    token = service.token

    return respond_with service unless token

    respond_with token: token, admin: AdminSerializer.new(admin)
  end

  def update
    token = Admins::BaseService.call({}, admin: current_admin).token

    respond_with token: token, admin: AdminSerializer.new(current_admin)
  end

  private

  def sign_in_params
    params.require(:admin).permit(:email, :password)
  end
end
