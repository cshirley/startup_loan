module StartupLoan
  class ApiResponse
    attr_reader :success, :result_count, :results,
                :error_code, :errors, :stats

    def initialize(data)
      @json = JSON.parse(data)
      @success = @json['success'] && !has_error?
      @json['results'].is_a?(Hash) ? parse_post : parse_get
    end

    def parse_post
      @stats = { failed:  @json['results'].delete('failed'),
                 success: @json['results'].delete('successful'),
                 total:   @json['results'].delete('total') }
      if success
        @results = @json['results']
        @result_count = @stats[:total]
      else
        @errors = @json['results'].values
      end
    end

    def parse_get
      @result_count = @json['numResults']
      @results = @json['results']
    end

    def has_error?
      @json['results'].is_a?(Hash) &&
        @json['results'].has_key?('failed') &&
        @json['results']['failed'] > 0
    end
  end
end
