module StartupLoan
  module ApplicantExtension
    def applicant_search(options = {})
      Applicant.find(self, options)
    end
    def applicant_dupe_search(email_address)
      applicants({emailaddress:email_address}).select { |a| a.is_duplicate? }
    end
  end
end
