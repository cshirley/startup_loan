module StartupLoan
  class Applicant < BaseModel
    set_attribute_keys %w(appid emailaddress postcode)

    def self.duplicates?(client, params)
      find_duplicates(client, params).count > 0
    end

    def self.find_duplicates(client, params)
      find(client, params).select(&:duplicate?)
    end

    def duplicate?
      attribute?('DUPLICATE')
    end
  end
end
