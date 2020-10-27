module SetCurrentRequestDetails
  extend ActiveSupport::Concern

  included do
    before_action do
      Current.user_agent = request.user_agent
      Current.client_ip  = request.remote_ip
    end
  end
end
