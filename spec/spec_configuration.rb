DEBUG = true
shared_context 'configuration' do
  let(:settings) do
    { base_uri: 'http://api.uat.sulserver.net/',
      api_key: 'iGy8G5dUmr9HXINAOc7MIG9m1bd8bv8K',
      debug: defined?('DEBUG'),
      logfile_path: 'debugging.log' }
  end

  let(:client) { StartupLoan::Client.new(settings) }

  let(:reference_type_names) do
    %w(journeystatus gender skillis ethnicity_new qualification
       employmentstatus wherehearnew otherfinancesource subsequentfinancesource
       declined_reason repaymentholidaylength statusatrepayment)
  end
end
