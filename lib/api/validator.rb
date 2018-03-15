require 'sinatra/json'
require_relative 'validation_helper'

module API
  module Validator
    include API::ValidationHelper

    EXPECTED_PARAMS = {
      to: :email,
      to_name: :string,
      from: :email,
      from_name: :string,
      subject: :string,
      body: :string
    }

    def invalid_request?
      EXPECTED_PARAMS.each do |key, type|
        unless @payload.has_key? key
          @error = "Missing key: #{key}"
          next  # Skips checking if key valid when key missing
        end

        unless valid_key? type, @payload[key]
          @error = "Invalid key: #{key}"
        end
      end

      !@error.nil?
    end

    def valid_key?(type, value)
      case type
      when :string then valid_string?(value)
      when :email then valid_email?(value)
      else false
      end
    end

    def bad_request_error
      halt 400, json({ error: @error })
    end

  end
end