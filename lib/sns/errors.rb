# encoding: utf-8

class Sns
  class SnsError < StandardError; end
  class AuthorizationError < SnsError; end
  class InternalError < SnsError; end
  class InvalidParameterError < SnsError; end
  class NotFoundError < SnsError; end
  class UndefinedError < SnsError; end
end