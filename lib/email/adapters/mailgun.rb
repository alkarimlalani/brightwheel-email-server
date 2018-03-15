require 'rest-client'

class Email
  module Adapters
    module Mailgun
      class << self

        BASE_URL = 'api.mailgun.net'
        API_VERSION = 'v3'
        PATH = 'messages'

        # Required methods

        def send_email(to:, to_name:, from:, from_name:, subject:, html:, text:)
          email_params = {
            from: "#{from_name} <#{from}>",
            to: "#{to_name} <#{to}>",
            subject: subject,
            html: html,
            text: text
          }
          resp = RestClient.post mailgun_url, email_params
          format_response(resp.body)
        end

        # Helper methods
        private

        def mailgun_url
          "https://api:#{ENV['MAILGUN_API_KEY']}" \
          "@#{BASE_URL}/#{API_VERSION}/#{ENV['MAILGUN_DOMAIN_NAME']}/#{PATH}"
        end

        def format_response(resp)
          orig_resp = JSON.parse(resp)
          {
            email_provider: 'mailgun',
            status: format_status(orig_resp['message']),
            id: orig_resp['id']
          }
        end

        def format_status(str)
          str.split('.')[0].downcase
        end

      end
    end
  end
end