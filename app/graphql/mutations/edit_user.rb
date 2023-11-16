require 'net/http'

class Mutations::EditUser < Mutations::BaseMutation
    argument :user, Types::EditProfileInputType
    
    field :user, Types::UserType
    field :errors, [String]

    def resolve(user:)
        # Prepare the request body
        user_data = {
            user: {
                email: user[:email],
                username: user[:username],
                password: user[:password],
                password_confirmation: user[:passwordConfirmation],
                current_password: user[:currentPassword]
            }
        }

        bearer_token = context[:headers]['Authorization']&.split('Bearer ')&.last
  
        # Make an HTTP PUT request to the backend server's RESTful API endpoint
        uri = URI('http://localhost:3000/users')
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Put.new(uri.path, { 
            'Content-Type' => 'application/json',
            'Authorization' => "Bearer #{bearer_token}"
        })
        request.body = user_data.to_json
  
        response = http.request(request)
        data = JSON.parse(response.body)

        # Check if the request was successful (HTTP status code 2xx)
        if response.is_a?(Net::HTTPSuccess)
            # Return the user data fetched from the backend server
            {
                user: data["user"],
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