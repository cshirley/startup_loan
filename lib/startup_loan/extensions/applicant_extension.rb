module StartupLoan
  module ApplicantExtension
    def applicant_search(options = {})
      Applicant.find(self, options)
    end

    def applicant_dupe_search(email_address)
      Applicant.find_duplicates(self, emailaddress: email_address)
    end
  end
end
