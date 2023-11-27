# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    field :id, ID
    field :email, String
    field :username, String
    field :displayName, String
    field :avatar, String
    field :token, String
    field :error, String
  end
end
