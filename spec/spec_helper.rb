# This file was originally copied from http://recipes.sinatrarb.com/p/testing/rspec
require 'dotenv/load'
require 'simplecov'
SimpleCov.start

require 'rack/test'
require 'rspec'

ENV['RACK_ENV'] = 'test'

require File.expand_path '../../app.rb', __FILE__

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

# For RSpec 2.x and 3.x
RSpec.configure do |config|
  config.include RSpecMixin
  config.before(:each) do
    # Stub RestClient
    RestClient ||= double
    response = double
    allow(response).to receive(:code).and_return(200)
    allow(response).to receive(:body).and_return("{\"id\":\"<20180315163303.1.E54A5226F65693EB@sandbox1681ccff4c3645d2a832b2a8bde3ce73.mailgun.org>\",\"message\":\"Queued. Thank you.\"}")
    allow(RestClient).to receive(:post).and_return(response)
  end

end