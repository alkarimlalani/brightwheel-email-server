require 'rest-client'

class Email
  module Adapters
    module Mandrill
      class << self

        BASE_URL = 'mandrillapp.com/api'
        API_VERSION = '1.0'
        PATH = 'messages/send.json'

        # Required methods

        def send_email(to:, to_name:, from:, from_name:, subject:, html:, text:)
          email_params = {
            key: ENV['MANDRILL_API_KEY'],
            message: {
              from_email: from,
              from_name: from_name,
              to: [
                {
                  email: to,
                  name: to_name
                }
              ],
              subject: subject,
              html: html,
              text: text
            },
            async: false
          }
          resp = RestClient.post mandrill_url, email_params
          format_response(resp.body)
        end

        # Helper methods
        private

        def mandrill_url
          "https://#{BASE_URL}/#{API_VERSION}/#{PATH}"
        end

        def format_response(resp)
          orig_resp = JSON.parse(resp).first
          {
            email_provider: 'mandrill',
            status: orig_resp['status'],
            id: orig_resp['_id']
          }
        end

      end
    end
  end
end