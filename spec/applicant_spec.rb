require 'spec_helper'

describe "Applicant API" do
  include_context "configuration"

  it "lists all applicants" do
    VCR.use_cassette("applicants_list_all_success") do
      partner_applicants = StartupLoan::Applicant.find(client)
    end
  end

  it "filters the list of applicants" do
    VCR.use_cassette("applicants_list_filtered_success") do
      filtered_applicants = StartupLoan::Applicant.find(client, surname:"shirley")
      expect(filtered_applicants.count).to be > 0
    end
  end

  it "checks for duplicate" do
     VCR.use_cassette("applicants_duplicate_check_success") do
      result = StartupLoan::Applicant.has_duplicate?(client, surname:"shirley")
      expect(result).to be true
    end
  end

  it "Adds applicant" do

  end

  it "Updates applicant" do
    partner_applicants = StartupLoan::Applicant.find(client)
    applicant = partner_applicants.first
    applicant.loanamount = 10000
    applicant.save
  end
end


