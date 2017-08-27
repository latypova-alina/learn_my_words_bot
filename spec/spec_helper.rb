require "dotenv"
require "word_info"
require "pry"
require "json"

module Helpers
  def fixture(name)
    JSON.parse(File.read("spec/fixtures/#{name}.json"))
  end
end

RSpec.configure do |config|
  config.include(Helpers)

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end
end
