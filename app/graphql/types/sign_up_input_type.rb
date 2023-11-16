# frozen_string_literal: true

module Types
  class SignUpInputType < Types::BaseInputObject
    argument :email, String
    argument :username, String
    argument :displayName, String
    argument :password, String
    argument :passwordConfirmation, String
  end
end
