ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/autorun"

class ActiveSupport::TestCase
  SEQUENCE = (1..Float::INFINITY).to_enum

  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def any_id
    -any_positive_id
  end

  def any_positive_id
    SEQUENCE.next
  end

  def any_time
    Time.zone.now
  end
end
