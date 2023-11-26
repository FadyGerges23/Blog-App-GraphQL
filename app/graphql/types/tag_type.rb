# frozen_string_literal: true

module Types
  class TagType < Types::BaseObject
    field :tagId, ID, null: false
    field :name, String, null: false
  end
end
