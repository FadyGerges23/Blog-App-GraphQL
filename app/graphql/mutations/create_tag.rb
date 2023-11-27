require 'net/http'

class Mutations::CreateTag < Mutations::BaseMutation
    argument :tag, Types::NewTagInputType
    
    field :tag, Types::TagType
    field :errors, [String]

    def resolve(tag:)
        # Prepare the request body
        tag_data = {
            name: tag[:name]
        }
  
        # Convert the post data to JSON
        json_data = tag_data.to_json

        bearer_token = context[:headers]['Authorization']&.split('Bearer ')&.last
  
        # Make an HTTP POST request to the backend server's RESTful API endpoint
        uri = URI("http://localhost:3000/tags")
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Post.new(uri.path, { 
            'Content-Type' => 'application/json',
            'Authorization' => "Bearer #{bearer_token}"
        })
        request.body = json_data
  
        response = http.request(request)
        data = JSON.parse(response.body)

        # Check if the request was successful (HTTP status code 2xx)
        if response.is_a?(Net::HTTPSuccess)
            # Return the post data fetched from the backend server
            {
                tag: {
                    tagId: data["tag"]["id"],
                    name: data["tag"]["name"]
                },
                errors: []
            }
        else
            {
                tag: nil,
                errors: data["errors"]
            }
        end
    end
end