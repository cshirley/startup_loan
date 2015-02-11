module StartupLoan
  class Client
    include ApplicantExtension

    attr_accessor :base_uri, :api_key

    def initialize(options = { base_uri: nil, api_key: nil })
      fail ArgumentError.new('You must specifiy valid options') unless options.keys.count > 0
      options.each do |k, v|
        fail ArgumentError.new("#{k} can not be nil or empty") if v.nil? || v.empty?
        send("#{k}=", v)
      end
    end

    def make_request_url(url, options)
      "#{url}?#{build_params(options)}"
    end

    def query_get_api(url, options)
      ApiResponse.new session.get(make_request_url(url, options)).body
    end

    def query_post_api(url, options)
      options.merge!(accessKey:api_key)
      response = session.post do |req|
        req.url url
        req.headers['Content-Type'] = 'application/json'
        req.body = options.to_json
      end
      ApiResponse.new response.body
    end

    def query_post_file(url, options, field_name, file_path)
      options.merge!(accessKey:api_key)
      mime_type = get_mime_type(file_path)
      options[field_name] = Faraday::UploadIO.new(file_path, mime_type)
      response = session.post url, options
      JSON.parse(response.body)
    end

    private

    def get_mime_type(file_path)
      `file -ib #{file_path}`.split(";").first
    end

    def build_params(options)
      options.merge!(accessKey:api_key)
      to_query(options)
    end

    def to_query(options)
      Faraday::Utils.build_nested_query(options)
    end

    def session
      @connection ||= ::Faraday.new(base_uri) do |conn|
        conn.request :multipart
        conn.adapter Faraday.default_adapter
        conn.use Faraday::Response::StartupLoan
      end
    end
  end
end
