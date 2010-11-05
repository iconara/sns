# encoding: utf-8


class Sns
  class Topic
    def initialize(arn, credentials)
      @arn, @credentials = arn, credentials
    end
    
    def publish(subject, message)
      Request.new(@credentials).send('TopicArn' => @arn, 'Action' => 'Publish', 'Subject' => subject, 'Message' => message)
    end
  end
end