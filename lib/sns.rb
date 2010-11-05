# encoding: utf-8

require 'cgi'
require 'hmac'
require 'hmac-sha2'
require 'time'
require 'base64'
require 'typhoeus'


class Sns
  class SnsError < StandardError; end
  class AuthorizationError < SnsError; end
  class InternalError < SnsError; end
  class InvalidParameterError < SnsError; end
  class NotFoundError < SnsError; end
  class UndefinedError < SnsError; end
  
  def initialize(access_key, secret_key, region='us-east-1')
    @credentials = AwsCredentials.new(access_key, secret_key, region)
  end
  
  def topic(arn)
    Topic.new(arn, @credentials)
  end
  
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
  
  class Topic
    def initialize(arn, credentials)
      @arn, @credentials = arn, credentials
    end
    
    def publish(subject, message)
      Request.new(@credentials).send('TopicArn' => @arn, 'Action' => 'Publish', 'Subject' => subject, 'Message' => message)
    end
  end
  
  class Request
    def initialize(credentials)
      @credentials = credentials
    end

    def send(parameters)
      parameters = default_parameters.merge(parameters)
      query_string = parameters.keys.sort.map { |k| "#{k}=#{url_escape(parameters[k])}" }.join('&')
      query_string += "&Signature=#{url_escape(@credentials.sign(query_string))}"
      do_request("http://#{@credentials.host}/?#{query_string}")
    end
    
  private
    
    def do_request(url)
      response = Typhoeus::Request.get(url)
      case response.code
      when 200 then puts(response.body); :ok
      when 400 then raise InvalidParameterError
      when 403 then raise AuthorizationError
      when 404 then raise NotFoundError
      when 500 then raise InternalError
      else raise UndefinedError
      end
    end
    
    def default_parameters
      {
        'Timestamp'        => Time.now.iso8601, 
        'AWSAccessKeyId'   => @credentials.access_key,
        'SignatureVersion' => 2,
        'SignatureMethod'  => 'HmacSHA256'
      }
    end
    
    def url_escape(str)
      CGI.escape(str.to_s).gsub('%7E', '~').gsub('+', '%20')
    end
  end
end
