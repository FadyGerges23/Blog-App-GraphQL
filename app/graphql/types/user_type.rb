# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    field :id, ID
    field :email, String
    field :username, String
    field :password, String
    field :passwordConfirmation, String
  end
end
