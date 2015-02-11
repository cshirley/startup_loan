module StartupLoan
  class Applicant < BaseModel
     def is_duplicate?
       has_attribute?("DUPLICATE")
     end
  end
end
