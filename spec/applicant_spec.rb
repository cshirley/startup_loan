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
      filtered_applicants = StartupLoan::Applicant.find(client, { surname:"shirley" })
    end
  end
  it "checks for duplicate" do
  end

  it "Adds applicant" do
  end
  it "Updates applicant" do
  end

end


