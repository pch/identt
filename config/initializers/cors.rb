# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # allow requests only from ClientApp domains
    origins { |source, env| ClientApp.exists?(base_url: source) }
    resource '*', headers: :any, methods: [:get, :post, :patch, :put, :delete], credentials: true
  end
end
