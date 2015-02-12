require 'spec_helper'

describe 'Applicant API' do
  include_context 'configuration'

  let(:new_applicant) do
    { 'journeystatus' => 1,
      'manadd' => 1,
      'firstname' => 'clive', 'surname' => 'shirley',
      'dob' => '1971-09-14',
      'address1' => '1 Croydon',
      'address2' => '12 Addiscomb Road',
      'citytown' => 'Croydon',
      'county' => 'surrey',
      'postcode' => 'CR00PG',
      'emailaddress' => 'test_user@foobar.com',
      'telephone' => '0777777777',
      'gender' => 'Male',
      'wherehearnew' => 14,
      'marketingagree' => 1,
      'referral_partner' => 0,
      'subdate' => "#{Time.now}" }
  end
  it 'lists all applicants' do
    VCR.use_cassette('applicants_list_all_success') do
      expect(StartupLoan::Applicant.find(client).class).to be Array
    end
  end

  it 'filters the list of applicants' do
    VCR.use_cassette('applicants_list_filtered_success') do
      filtered_applicants = StartupLoan::Applicant.find(client, surname: 'shirley')
      expect(filtered_applicants.count).to be > 0
    end
  end

  it 'checks for duplicate' do
    VCR.use_cassette('applicants_duplicate_check_success') do
      result = StartupLoan::Applicant.duplicates?(client, surname: 'shirley')
      expect(result).to be true
    end
  end

  it 'Adds applicant Registration state' do
    pending 'Waiting on startuploans'
    # VCR.use_cassette("application_add_new_registration") do
    applicant = StartupLoan::Applicant.new(client, new_applicant)
    applicant.save
    # end
  end

  it 'Updates applicant' do
    pending 'Waiting on startuploans'
    partner_applicants = StartupLoan::Applicant.find(client, journeystatus: 1)
    applicant = partner_applicants.first
    applicant.loanamount = 10_000
    applicant.save
  end
end
