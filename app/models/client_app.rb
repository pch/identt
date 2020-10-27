class ClientApp < ApplicationRecord
  include RandomToken

  has_many :users
  has_many :sessions

  before_create { generate_base64_token(:api_key) }
  before_create :generate_api_secret

  def callback_url(extra_query_params)
    uri = Addressable::URI.parse(base_callback_url)
    uri.query_values = (uri.query_values || {}).merge(extra_query_params)
    uri.to_s
  end

  private

    def generate_api_secret
      self.api_secret = SecureRandom.hex(64)
    end
end
