require 'net/http'

class Mutations::SignOutUser < Mutations::BaseMutation    
    field :is_sign_out_successful, Boolean

    def resolve
        bearer_token = context[:headers]['Authorization']&.split('Bearer ')&.last
        
        # Make an HTTP POST request to the backend server's RESTful API endpoint
        uri = URI('http://localhost:3000/users/sign_out')
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Delete.new(uri.path, {
             'Content-Type' => 'application/json',
             'Authorization' => "Bearer #{bearer_token}"
        })
        response = http.request(request)
  
        # Check if the request was successful (HTTP status code 2xx)
        if response.is_a?(Net::HTTPSuccess)
            {
                is_sign_out_successful: true
            }
        else
            {
                is_signout_successful: false
            }
        end
    end
end