module Hooker
  class Application < Sinatra::Base
    set :token, ENV['TRAVIS_USER_TOKEN']

    get '/' do
      'alive'
    end
    
    get '/whois' do
      env['HTTP_REFERER']
    end
    
    get 'badge' do
      env['HTTP_REFERER'] =~ /https:\/\/github.com\/.*\/tree\/(.*)$/ # support only github
      branch = $1 || "master"
      redirect_url = params[:redirect_url].gsub(/REPLACE_THIS/, branch)
      redirect redirect_url
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
      # Format: http://docs.travis-ci.com/user/notifications/#Webhooks-Delivery-Format
      build_url  = body['build_url']
      status     = body['status_message']
      branch     = body['branch']
      ~<<-RESULT
      [#{status}] #{repo_slug} (#{branch})
      #{URI.encode(build_url)}
      RESULT
    end
  end
end
