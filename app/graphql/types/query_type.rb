# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [Types::NodeType, null: true], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ID], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :current_user, Types::CurrentUserType, null: false

    def current_user
      bearer_token = context[:headers]['Authorization']&.split('Bearer ')&.last
    
      # Make an HTTP POST request to the backend server's RESTful API endpoint
      uri = URI('http://localhost:3000/current_user')
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.path, { 
        'Accept' => 'application/json',
        'Authorization' => "Bearer #{bearer_token}"
      })

      response = http.request(request)
      data = JSON.parse(response.body)

      # Check if the request was successful (HTTP status code 2xx)
      if response.is_a?(Net::HTTPSuccess)
          # Return the user data fetched from the backend server
          {
              email: data["email"],
              username: data["username"],
              displayName: data["display_name"],
              avatar: data["avatar_url"],
              posts: data["posts"],
              error: nil
          }
      else
          {
              email: nil,
              username: nil,
              displayName: nil,
              avatar: nil,
              posts: nil,
              error: data["error"]
          }
      end
    end


    field :post, Types::PostType do
      argument :userId, ID
      argument :postId, ID
    end

    def post(userId:, postId:)
      bearer_token = context[:headers]['Authorization']&.split('Bearer ')&.last
    
      uri = URI("http://localhost:3000/users/#{userId}/posts/#{postId}")
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.path, { 
        'Accept' => 'application/json',
        'Authorization' => "Bearer #{bearer_token}"
      })

      response = http.request(request)
      data = JSON.parse(response.body)

      if response.is_a?(Net::HTTPSuccess)
          {
              id: data["id"],
              title: data["title"],
              body: data["body"]
          }
      else
          {
            id: nil,
            title: nil,
            body: nil
          }
      end
    end

  end
end
