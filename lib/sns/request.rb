# encoding: utf-8

require 'cgi'
require 'time'
require 'typhoeus'


class Sns
  class Request
    def initialize(credentials)
      @credentials = credentials
    end

    def send(parameters)
      parameters = default_parameters.merge(parameters)
      query_string = parameters.keys.sort.map { |k| "#{k}=#{url_escape(parameters[k])}" }.join('&')
      signature = @credentials.sign(query_string)
      query_string += "&Signature=#{url_escape(signature)}"
      get("http://#{@credentials.host}/?#{query_string}")
    end
  
  private
  
    def get(url)
      response = Typhoeus::Request.get(url)
      case response.code
      when 200 then :ok
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