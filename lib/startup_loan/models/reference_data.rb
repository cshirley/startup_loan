module StartupLoan
  class ReferenceData < BaseModel
    def self.resource_name
      'applicants/ref_data'
    end

    def save
      fail StartupLoan::NotSupported.new('')
    end

    def self.build_url(resource_action)
      resource_action == :search ? resource_name : super
    end

    def self.process_response(connection, response)
      response.results.inject([]) do |arr, hash_item|
        k, v = hash_item
        data = { 'reference_type_name' => k }.merge(v)
        arr << new(connection, data, true)
      end
    end
  end
end
