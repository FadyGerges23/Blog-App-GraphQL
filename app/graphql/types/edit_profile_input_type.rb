# frozen_string_literal: true

module Types
  class EditProfileInputType < Types::BaseInputObject
    argument :id, ID
    argument :email, String
    argument :username, String
    argument :displayName, String
    argument :password, String, required: false
    argument :passwordConfirmation, String, required: false
    argument :currentPassword, String
  end
end
