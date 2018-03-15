require 'nokogiri'
require 'json'
require 'rest-client'
require_relative 'adapters/mailgun'
require_relative 'adapters/mandrill'

class Email

  def initialize(email_hash)
    @email_hash = email_hash
    set_email_content!
    @email_adapter = case ENV['EMAIL_PROVIDER']
                    when 'mailgun' then Email::Adapters::Mailgun
                    when 'mandrill' then Email::Adapters::Mandrill
                    end
  end

  # Note: All email adapters should implement a `send` method on
  #       the module which responds with a hash of the format:
  #       {status: 'EMAIL_STATUS', id: 'EMAIL_ID', email_provider: 'EMAIL_PROVIDER'}
  def deliver
    resp = @email_adapter.send_email(@email_hash)
  end

  private

  def set_email_content!
    @email_hash[:text] = to_plain_text @email_hash[:body]
    @email_hash[:html] = @email_hash.delete(:body)
  end

  def to_plain_text(html)
    doc = Nokogiri::HTML(html)
    elems = doc.xpath("//body").children
    text = elems.inject('') { |str, elem| str + elem.text + " " }
    text.chop
  end

end