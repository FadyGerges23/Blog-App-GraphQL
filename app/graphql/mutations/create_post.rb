require 'net/http'

class Mutations::CreatePost < Mutations::BaseMutation
    argument :post, Types::NewPostInputType
    
    field :post, Types::PostType
    field :errors, [String]

    def resolve(post:)
        # Prepare the request body
        post_data = {
            title: post[:title],
            body: post[:body],
            category_id: post[:categoryId],
            tags_ids: post[:tagsIds]
        }
  
        # Convert the post data to JSON
        json_data = post_data.to_json

        bearer_token = context[:headers]['Authorization']&.split('Bearer ')&.last
  
        # Make an HTTP POST request to the backend server's RESTful API endpoint
        uri = URI("http://localhost:3000/users/#{post[:userId]}/posts")
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
                post: data["post"],
                errors: []
            }
        else
            {
                post: nil,
                errors: data["errors"]
            }
        end
    end
end