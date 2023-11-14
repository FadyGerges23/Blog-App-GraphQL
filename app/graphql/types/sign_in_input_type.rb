# frozen_string_literal: true

module Types
  class SignInInputType < Types::BaseInputObject
    argument :emailOrUsername, String
    argument :password, String
  end
end
