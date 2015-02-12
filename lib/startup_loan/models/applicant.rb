module StartupLoan
  class Applicant < BaseModel
    set_attribute_keys %w(loanid appid)

    def self.has_duplicate?(client, params)
      find_duplicates(client,params).count > 0
    end

    def self.find_duplicates(client, params)
      find(client, params).select(&:is_duplicate?)
    end

    def is_duplicate?
      has_attribute?("DUPLICATE")
    end
  end
end
