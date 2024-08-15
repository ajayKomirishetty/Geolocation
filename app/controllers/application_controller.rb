class ApplicationController < ActionController::API
    # before_action :authenticate
  
    private
  
    def authenticate
      authenticate_or_request_with_http_token do |token, _options|
        # Check against an ENV token or database token
        token == ENV['API_TOKEN']
      end
    end
  end
  