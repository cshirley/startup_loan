require 'spec_helper'

describe 'API Response' do
  let(:success_payload) do
    { success: true,
      numResults: 2,
      results: ['result one', 'result two'] }
  end
  let(:failed_payload) do
    { success: true,
      results: { failed: 1, successful: 0, total: 1, '0' => 'error 1', '1' => 'error 2' } }
  end

  it 'processed successful responses' do
    result = StartupLoan::ApiResponse.new(success_payload.to_json)
    expect(result.result_count).to eq 2
    expect(result.success).to eq true
    expect(result.results).to match_array(success_payload[:results])
    expect(result.errors).to be nil
    expect(result.error_code).to be nil
    expect(result.stats).to be nil
  end

  it 'processed failed responses' do
    result = StartupLoan::ApiResponse.new(failed_payload.to_json)
    expect(result.result_count).to be nil
    expect(result.success).to eq false
    expect(result.results).to be nil
    expect(result.errors).to match_array(['error 1', 'error 2'])
  end
end
