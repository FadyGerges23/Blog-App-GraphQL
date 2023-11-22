# frozen_string_literal: true

module Types
    class UpdatePostInputType < Types::BaseInputObject
      argument :userId, ID
      argument :postId, ID
      argument :title, String
      argument :body, String
    end
  end