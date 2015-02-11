module StartupLoan
  class ReferenceData < BaseModel

    def self.resource_name
      "applicants/ref_data"
    end

    def save
      fail StartupLoan::NotSupported.new("")
    end

    def self.build_url(resource_action)
      resource_action == :search ? self.resource_name : super
    end

    def self.process_response(connection, response)
      response.results.inject([]) do |arr, data_item|
        data = { "reference_type_name" => data_item[0] }.merge(data_item[1])
        arr << new(connection, data, true)
      end
    end

  end
end
