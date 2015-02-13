require 'spec_helper'

describe 'client' do
  include_context 'configuration'

  describe 'client setup' do
    it 'should return the correct base URL' do
      expect(client.base_uri).to eql settings[:base_uri]
    end
    it 'should format the api request' do
      url = client.make_request_url('', zzzz: 'foobar')
      expect(url).to eql "?accessKey=#{settings[:api_key]}&zzzz=foobar"
    end
  end

  describe 'sessions' do
    it 'fails due to invalid api_key' do
      VCR.use_cassette('client_session_invalid_api_key') do
        expect do
          invalid_client = StartupLoan::Client.new(settings.merge(api_key: 'foobar'))
          invalid_client.applicant_search
        end.to raise_error(StartupLoan::AuthenticationError)
      end
    end
  end

  describe 'transport support' do
    it 'returns the mimetype for the file' do
      expect(client.send :get_mime_type, __FILE__).to eq 'text/x-ruby'
    end
  end
end
