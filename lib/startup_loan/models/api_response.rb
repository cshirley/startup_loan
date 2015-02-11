module StartupLoan
  class ApiResponse
    attr_accessor :success, :result_count, :results, :error_code, :errors
    def initialize(data)
      @json = JSON.parse(data)
      self.success = @json['success']
      if success
        self.result_count = @json['numResults']
        self.results = @json['results']
      else

      end
    end
  end
end

