options = {
  consumer_key:        ENV["TWITTER_CONSUMER_KEY"],
  consumer_secret:     ENV["TWITTER_CONSUMER_SECRET"],
  access_token:        ENV["TWITTER_ACCESS_TOKEN"],
  access_token_secret: ENV["TWITTER_ACCESS_TOKEN_SECRET"],
}

TWITTER_CLIENT = Twitter::REST::Client.new(options)