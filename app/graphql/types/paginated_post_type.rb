# frozen_string_literal: true

module Types
  class PaginatedPostType < Types::BaseObject
    field :pagePosts, [Types::PostType]
    field :pagesCount, Integer
  end
end
