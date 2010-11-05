# encoding: utf-8

require 'hmac'
require 'hmac-sha2'
require 'base64'


class Sns
  class AwsCredentials
    attr_reader :access_key, :host
  
    def initialize(access_key, secret_key, region)
      @access_key, @secret_key = access_key, secret_key
      @host = "sns.#{region}.amazonaws.com"
    end
  
    def sign(query_string, method='GET')
      hmac = HMAC::SHA256.new(@secret_key)
      hmac.update("#{method}\n#{@host}\n/\n#{query_string}")
      signature = Base64.encode64(hmac.digest).chomp
    end
  end
end