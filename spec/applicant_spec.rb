require 'spec_helper'

describe 'Applicant API' do
  include_context 'configuration'

  let(:new_applicant) do
    { 'journeystatus' => 1,
      'manadd' => 1,
      'firstname' => 'clive brian', 'surname' => 'shirley',
      'dob' => '1971-09-14',
      'address1' => 'Fifty Pence Building',
      'address2' => '12 Addiscomb Road',
      'citytown' => 'Croydon',
      'county' => 'surrey',
      'postcode' => 'CR2 0LN',
      'emailaddress' => 'test_user_2@foobar.com',
      'telephone' => '0777888888',
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
  it 'reloads data from first applicants' do
    VCR.use_cassette('applicants_list_all_reload_first_success') do
      result = StartupLoan::Applicant.find(client)
      applicant = result.first
      applicant_org = applicant.dup
      expect(applicant.reload!).to eq true
      applicant_org.attributes.keys.each { |k|
        expect(applicant_org.send(k)).to eq applicant.send(k)
      }
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

  it 'checks for duplicate throught the applicant extension' do
    VCR.use_cassette('applicant_extension_duplicate_check_success') do
      expect(client.applicant_dupe_search("clive.shirley@mac.com").empty?).to be true
    end
  end

  it 'Adds applicant Registration state' do
    VCR.use_cassette("application_add_new_registration") do
      applicant = StartupLoan::Applicant.new(client, new_applicant)
      begin
      applicant.save
      rescue StartupLoan::ApiException => ex
        ex.errors.each { |e|
          puts e
        }
        raise
      end
    end
  end

  it 'Updates applicant' do
    VCR.use_cassette("application_update_existing_registration") do
      partner_applicants = StartupLoan::Applicant.find(client, journeystatus: 1)
      applicant = partner_applicants.first
      applicant.loanamount = 10000
      applicant.save
    end
  end
end
