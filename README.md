SNS
===

Example:

    sns = Sns.new(aws_access_key, aws_secret_key)
    sns.topic('arn:aws:sns:us-east-1:123456789012:test')
    sns.publish('Hello', 'World')