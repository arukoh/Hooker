module Hooker
  class Application < Sinatra::Base
    set :token, ENV['TRAVIS_USER_TOKEN']

    get '/' do
      'alive'
    end

    post '/travis' do
      return 403 unless valid_request?

      body = JSON.parse(params[:payload])
      TWITTER_CLIENT.update(travis_result(body))
      204
    end

    private
    def valid_request?
      digest = Digest::SHA2.new.update("#{repo_slug}#{settings.token}")
      digest.to_s == authorization
    end

    def authorization
      env['HTTP_AUTHORIZATION']
    end

    def repo_slug
      env['HTTP_TRAVIS_REPO_SLUG']
    end

    def travis_result(body)
      build_url  = body['build_url']
      status     = body['status_message']
      repository = body['repository']['name']
      owner      = body['repository']['owner_name']
      [
        "[#{status}] #{owner}/#{repository}",
        URI.encode(build_url)
      ].join("\n")
    end
  end
end
