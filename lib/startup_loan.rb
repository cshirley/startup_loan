require 'logger'
require 'json'
require 'faraday'
require "faraday/detailed_logger"
require "startup_loan/version"
require "startup_loan/errors"
require "startup_loan/responses"
require "startup_loan/extensions/applicant_extension"
require "startup_loan/client"
require "startup_loan/modules/attribute_validation"
require "startup_loan/modules/model_attributes"
require "startup_loan/models/base_model"
require "startup_loan/models/applicant"
require "startup_loan/models/reference_data"
require "startup_loan/models/api_response"

module StartupLoan
  # Your code goes here...
end
