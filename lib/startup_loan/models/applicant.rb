module StartupLoan
  class Applicant < BaseModel
    def self.has_duplicate?(client, params)
      self.find_duplicates(client,params).count > 0
    end
    def self.find_duplicates(client, params)
      find(client, params).select { |applicant| applicant.is_duplicate? }
    end
    def is_duplicate?
      has_attribute?("DUPLICATE")
    end
  end
end
