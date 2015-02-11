module Faraday
  class Response::StartupLoan < Response::Middleware
    def call(env)
      @app.call(env).on_complete do
        check_status(env[:response_headers])
      end
    end

    def check_status(headers)
      if headers && headers.has_key?("location") &&
         headers["location"].include?("denied")
        fail StartupLoan::AuthenticationError.new(401, "Access Denied")
      end
    end
  end
end
