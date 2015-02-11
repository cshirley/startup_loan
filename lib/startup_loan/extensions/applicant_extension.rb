module StartupLoan
  module ApplicantExtension
    def applicants(options = {})
      Applicant.find(self, options)
    end
  end
end
