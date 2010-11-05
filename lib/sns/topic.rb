# encoding: utf-8


class Sns
  class Topic
    def initialize(arn, credentials)
      @arn, @credentials = arn, credentials
    end
    
    def publish(subject, message)
      send_request('Action' => 'Publish', 'Subject' => subject, 'Message' => message)
    end
    
    def subscribe(protocol, endpoint)
      send_request('Action' => 'Subscribe', 'Protocol' => protocol, 'Endpoint' => endpoint)
    end
    
  private
  
    def send_request(parameters)
      Request.new(@credentials).send(parameters.merge('TopicArn' => @arn))
    end
  end
end