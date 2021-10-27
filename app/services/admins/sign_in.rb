class Admins::SignIn < Admins::BaseService
  validates :email, :password, presence: true

  validate :password_is_correct
end
