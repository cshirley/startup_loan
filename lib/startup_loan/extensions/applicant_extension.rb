module StartupLoan
  module ApplicantExtension
    def applicant_search(options = {})
      Applicant.find(self, options)
    end

    def applicant_dupe_search(email_address)
      applicants(emailaddress: email_address).select(&:duplicate?)
    end
  end
end
