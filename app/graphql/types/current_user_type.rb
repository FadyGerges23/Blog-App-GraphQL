# frozen_string_literal: true

module Types
  class CurrentUserType < Types::BaseObject
    field :email, String
    field :username, String
    field :displayName, String
    field :avatar, String
    field :error, String
  end
end