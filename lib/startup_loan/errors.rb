module StartupLoan
  class BaseError < StandardError
    attr_accessor :result_code, :errors
    def initialize(result_code, message, errors = [])
      @result_code = result_code
      @errors = errors
      super(message)
    end
  end
  class AuthenticationError < BaseError; end
  class ApiException < BaseError; end
  class InvalidParameterError < BaseError; end
  class NotSupported < StandardError; end
  class DuplicateApplicant < BaseError; end
end
