require 'net/http'

class Mutations::SignUpUser < Mutations::BaseMutation
    argument :email, String, required: true
    argument :username, String, required: true
    argument :password, String, required: true
    argument :passwordConfirmation, String, required: true

    field :user, Types::UserType
    # field :errors, [String]

    def resolve(email:, username:, password:, passwordConfirmation:)
        # Prepare the request body
        user_data = {
            user: {
                email: email,
                username: username,
                password: password,
                password_confirmation: passwordConfirmation
            }
        }
  
        # Convert the user data to JSON
        json_data = user_data.to_json
  
        # Make an HTTP POST request to the backend server's RESTful API endpoint
        uri = URI('http://localhost:3000/users')
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Post.new(uri.path, { 'Content-Type' => 'application/json' })
        request.body = json_data
  
        response = http.request(request)
  
        # Check if the request was successful (HTTP status code 2xx)
        if response.is_a?(Net::HTTPSuccess)
            data = JSON.parse(response.body)
  
            # Return the user data fetched from the backend server
            {
                user: data["user"]
            }
        else
            # Handle the case when the request was not successful
            # You might want to raise an exception or return an error message
            raise StandardError, "Failed to sign up user. HTTP Status: #{response.code}, Response Body: #{response.body}"
        end
    end
end