require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # Use selenium chrome in future when browser available; fallback to rack_test for simple DOM assertions
  driven_by :rack_test
end
