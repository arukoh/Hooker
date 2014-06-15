ENV['RACK_ENV']          = 'test'
ENV['TRAVIS_USER_TOKEN'] = '1234567890'
require './config/boot'
require 'rack/test'

module Helpers
  def travis_body
    payload = <<-BODY
{
  "build_url": "https://travis-ci.org/arukoh/Hooker/builds/1",
  "status_message": "Passed",
  "repository": {
    "name":       "Hooker",
    "owner_name": "arukoh"
  }
}
    BODY
    URI.encode("payload=#{payload}")
  end

  def travis_authorization
    str = "arukoh/Hooker#{ENV['TRAVIS_USER_TOKEN']}"
    Digest::SHA2.hexdigest(str)
  end
end

RSpec.configure do |c|
  c.include Rack::Test::Methods
  c.include Helpers
end
