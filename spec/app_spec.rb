require 'spec_helper'

describe 'The Hooker App' do
  include Rack::Test::Methods

  def app
    Hooker::Application
  end

  it "says alive" do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('alive')
  end

  it "tweet build result of Travis CI" do
    allow_any_instance_of(Twitter::REST::Client).to receive(:update).and_return true
    payload = <<-BODY
{
  "build_url": "https://travis-ci.org/arukoh/Hooker/builds/1",
  "status_message": "Passed",
  "repository": { "name": "Hooker", "owner_name": "arukoh" }
}
    BODY
    URI.encode("payload=#{payload}")
    rack_env = {
      'HTTP_TRAVIS_REPO_SLUG' => 'arukoh/Hooker',
      'HTTP_AUTHORIZATION' => Digest::SHA2.hexdigest("arukoh/Hooker#{ENV['TRAVIS_USER_TOKEN']}")
    }
    post '/travis', travis_body, rack_env
    expect(last_response.status).to eq(204)
  end
end
