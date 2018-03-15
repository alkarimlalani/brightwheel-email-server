module API
  module ValidationHelper

    # Email Regex taken from https://stackoverflow.com/questions/22993545/ruby-email-validation-with-regex
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

    def valid_string?(str)
      return false unless str.is_a? String
      !str.empty?
    end

    def valid_email?(email)
      return false unless valid_string?(email)
      !(VALID_EMAIL_REGEX =~ email).nil?
    end
  end
end