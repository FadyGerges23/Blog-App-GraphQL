# frozen_string_literal: true

module Types
  class SignOutInputType < Types::BaseInputObject
    argument :id, ID
    argument :email, String
    argument :username, String
  end
end
