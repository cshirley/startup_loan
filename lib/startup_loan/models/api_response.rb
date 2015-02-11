module StartupLoan
  class ApiResponse
    attr_accessor :success, :result_count, :results, :error_code, :errors

    def initialize(data)
      @json = JSON.parse(data)
      self.success = @json['success'] && !has_error?
      @json['results'].is_a?(Hash) ? parse_post : parse_get
    end

    def parse_post
       failed_count =  @json["results"].delete("failed")
       success_count =  @json["results"].delete("successful")
       total_count =  @json["results"].delete("total")

       if self.success
         self.results = @json["results"]
         self.result_cont = total_count
        else
          self.errors = @json["results"].values
        end
    end

    def parse_get
      self.result_count = @json['numResults']
      self.results = @json['results']
    end

    def has_error?
      @json['results'].is_a?(Hash) &&
        @json['results'].has_key?("failed") &&
        @json['results']["failed"] > 0
    end
  end
end

