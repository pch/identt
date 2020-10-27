
test_app = ClientApp.find_or_create_by(identifier: "test_app")
test_app.name = "Test App"
test_app.base_url = "http://localhost:3000"
test_app.base_callback_url = "http://localhost:3000/auth/"
test_app.save

ap test_app

