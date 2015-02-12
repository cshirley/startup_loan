shared_context "configuration" do

  let(:settings) do
    { base_uri: "http://api.uat.sulserver.net/",
      api_key: "iGy8G5dUmr9HXINAOc7MIG9m1bd8bv8K",
      debug: true,
      logfile_path: "debugging.log" }
  end

  let(:client) { StartupLoan::Client.new(settings) }

  let(:reference_type_names) do
    ["journeystatus", "gender", "skillis", "ethnicity_new", "qualification",
     "employmentstatus", "wherehearnew", "otherfinancesource",
     "subsequentfinancesource", "declined_reason", "repaymentholidaylength",
     "statusatrepayment"]
  end
end
