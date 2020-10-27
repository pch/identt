class UserAction < ApplicationRecord
  belongs_to :user
  belongs_to :session
  belongs_to :client_app

  def self.track!(action:, data: {})
    create! \
      user: Current.session.user,
      session: Current.session,
      client_app: Current.session.user.client_app,
      action: action,
      data: data
  end
end
