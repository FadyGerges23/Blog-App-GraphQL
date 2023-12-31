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

    field :current_user, Types::UserType, null: false

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
              id: data["id"],
              email: data["email"],
              username: data["username"],
              displayName: data["display_name"],
              avatar: data["avatar_url"],
              error: nil
          }
      else
          {
              email: nil,
              username: nil,
              displayName: nil,
              avatar: nil,
              error: data["error"]
          }
      end
    end

    
    def generate_tags_query(tags_ids)
      query = []
      if tags_ids && tags_ids.length > 0
        tags_ids.each do |tag_id|
          query << "q[id_in][]=#{tag_id}"
        end
        tags_query = query.join("&")
      end
    end


    field :user_posts, Types::PaginatedPostType do
      argument :userId, ID
      argument :pageNumber, String, required: false, default_value: "1"
      argument :title, String, required: false, default_value: ""
      argument :description, String, required: false, default_value: ""
      argument :category_id, ID, required: false, default_value: ""
      argument :tags_ids, [ID], required: false, default_value: []
    end

    def user_posts(userId:, pageNumber:, title:, description:, category_id:, tags_ids:)
      bearer_token = context[:headers]['Authorization']&.split('Bearer ')&.last
      tags_query = generate_tags_query(tags_ids)
    
      uri = URI("http://localhost:3000/users/#{userId}/posts/page/#{pageNumber}?q[title_cont]=#{title}&q[body_cont]=#{description}&q[category_id_eq]=#{category_id}&#{tags_query}")
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri, { 
        'Accept' => 'application/json',
        'Authorization' => "Bearer #{bearer_token}"
      })

      response = http.request(request)
      data = JSON.parse(response.body)

      if response.is_a?(Net::HTTPSuccess)
        {
          pagePosts: data["posts"],
          pagesCount: data["pagesCount"]
        }
      else
          nil
      end
    end


    field :user_post, Types::PostType do
      argument :userId, ID
      argument :postId, ID
    end

    def user_post(userId:, postId:)
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
          data
      else
          nil
      end
    end

    
    field :categories, [Types::CategoryType]

    def categories
      uri = URI("http://localhost:3000/categories")
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.path, { 'Accept' => 'application/json' })

      response = http.request(request)
      data = JSON.parse(response.body)
 
      if response.is_a?(Net::HTTPSuccess)
          data["categories"]
      else
          nil
      end
    end


    field :tags, [Types::TagType]

    def tags
      uri = URI("http://localhost:3000/tags")
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.path, { 'Accept' => 'application/json' })

      response = http.request(request)
      data = JSON.parse(response.body)
 
      if response.is_a?(Net::HTTPSuccess)
          tags = data["tags"].map do |tag| 
            {
              tagId: tag["id"],
              name: tag["name"]
            }
          end
      else
          nil
      end
    end

    
    field :posts, PaginatedPostType do
      argument :pageNumber, String, required: false, default_value: "1"
      argument :title, String, required: false, default_value: ""
      argument :description, String, required: false, default_value: ""
      argument :category_id, ID, required: false, default_value: ""
      argument :tags_ids, [ID], required: false, default_value: []
    end

    def posts(pageNumber:, title:, description:, category_id:, tags_ids:)
      tags_query = generate_tags_query(tags_ids)
      
      uri = URI("http://localhost:3000/posts/page/#{pageNumber}?q[title_cont]=#{title}&q[body_cont]=#{description}&q[category_id_eq]=#{category_id}&#{tags_query}")
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri, { 'Accept' => 'application/json' })

      response = http.request(request)
      data = JSON.parse(response.body)

      if response.is_a?(Net::HTTPSuccess)
          {
            pagePosts: data["posts"],
            pagesCount: data["pagesCount"]
          }
      else
          nil
      end
    end


    field :post, Types::PostType do
      argument :postId, ID
    end

    def post(postId:)    
      uri = URI("http://localhost:3000/posts/#{postId}")
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.path, { 'Accept' => 'application/json' })

      response = http.request(request)
      data = JSON.parse(response.body)

      if response.is_a?(Net::HTTPSuccess)
          data
      else
          nil
      end
    end

  end
end
