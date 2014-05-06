$stdout.sync = true # so that foreman will print out stuff
require 'tweetstream'
require 'geocoder'

TweetStream.configure do |config|
  config.consumer_key       = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret    = ENV['TWITTER_CONSUMER_SECRET']
  config.oauth_token        = ENV['TWITTER_OAUTH_TOKEN']
  config.oauth_token_secret = ENV['TWITTER_OAUTH_TOKEN_SECRET']
  config.auth_method        = :oauth
end

Geocoder.configure(
  :lookup => :nominatim,
  :http_headers => { "User-Agent" => ENV['NOMINATIM_CONTACT'] }
)

def geocode(latlong)
  return if latlong.nil?
  Geocoder.search([latlong.first, latlong.last]).
  first.
  data["address"]["country"]
end

# This will pull a sample of all tweets based on
# your Twitter account's Streaming API role.

puts "Starting TweetStream"
TweetStream::Client.new.filter(locations: '-180,-90,180,90') do |status|
  # The status object is a special Hash with
  # method access to its keys.
  puts "#{status.text}"
  puts "#{status.geo.to_h[:coordinates]}"
  puts "#{geocode(status.geo.to_h[:coordinates])}"
  puts "----------------------"
  sleep 2
end

