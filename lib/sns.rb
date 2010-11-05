# encoding: utf-8

require 'sns/version'
require 'sns/errors'
require 'sns/topic'
require 'sns/aws_credentials'
require 'sns/request'


class Sns
  def initialize(access_key, secret_key, region='us-east-1')
    @credentials = AwsCredentials.new(access_key, secret_key, region)
  end
  
  def topic(arn)
    Topic.new(arn, @credentials)
  end
end
