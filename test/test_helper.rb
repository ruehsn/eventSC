ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Helper to log in as admin for controller tests
    def login_as_admin_controller
      admin = users(:admin)
      @controller.session[:user_id] = admin.id if @controller
    end

    # Helper to log in as admin for integration tests
    def login_as_admin_integration
      admin = users(:admin)
      post "/dev_login", params: { email: admin.email }
      follow_redirect!
    end
    # Add more helper methods to be used by all tests here...
  end
end
