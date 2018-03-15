require 'sinatra'
require 'sinatra/json'
require 'json'
require 'dotenv/load'
require_relative 'lib/utils'
require_relative 'lib/api/validator'
require_relative 'lib/email/email'

include Utils
include API::Validator

before do
  set_payload
  if invalid_request?
    bad_request_error
  end
end

post '/email', :provides => :json do
  email = Email.new(@payload)
  resp = email.deliver
  json resp
end
