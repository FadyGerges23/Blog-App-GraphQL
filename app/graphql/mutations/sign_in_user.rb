require 'net/http'

class Mutations::SignInUser < Mutations::BaseMutation
    argument :user, Types::SignInInputType
    
    field :user, Types::UserType
    field :errors, [String]

    def resolve(user:)
        # Prepare the request body
        user_data = {
            user: {
                email_or_username: user[:emailOrUsername],
                password: user[:password]
            }
        }
  
        # Convert the user data to JSON
        json_data = user_data.to_json
  
        # Make an HTTP POST request to the backend server's RESTful API endpoint
        uri = URI('http://localhost:3000/users/sign_in')
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Post.new(uri.path, { 'Content-Type' => 'application/json' })
        request.body = json_data
  
        response = http.request(request)
        data = JSON.parse(response.body)
        bearer_token = response['Authorization']&.split('Bearer ')&.last
  
        # Check if the request was successful (HTTP status code 2xx)
        if response.is_a?(Net::HTTPSuccess)
            # Return the user data fetched from the backend server
            {
                user: data["user"].merge({ token: bearer_token }),
                errors: []
            }
        else
            {
                user: nil,
                errors: data["errors"]
            }
        end
    end
end