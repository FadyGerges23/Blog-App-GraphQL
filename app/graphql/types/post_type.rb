# frozen_string_literal: true

module Types
  class PostType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :body, String, null: false
    field :category, Types::CategoryType
    field :tags, [Types::TagType]
    field :user, Types::UserType
  end
end
