require 'net/http'

class Mutations::DeletePost < Mutations::BaseMutation
    argument :post, Types::DestroyPostInputType
    
    field :is_delete_successful, Boolean

    def resolve(post:)
        bearer_token = context[:headers]['Authorization']&.split('Bearer ')&.last
  
        # Make an HTTP POST request to the backend server's RESTful API endpoint
        uri = URI("http://localhost:3000/users/#{post[:userId]}/posts/#{post[:postId]}")
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Delete.new(uri.path, { 
            'Content-Type' => 'application/json',
            'Authorization' => "Bearer #{bearer_token}"
        })
  
        response = http.request(request)

        if response.is_a?(Net::HTTPSuccess)
            {
                is_delete_successful: true
            }
        else
            {
                is_delete_successful: false
            }
        end
    end
end