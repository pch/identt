class Current < ActiveSupport::CurrentAttributes
  attribute :session, :user_agent, :client_ip
end
