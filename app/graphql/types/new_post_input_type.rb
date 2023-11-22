# frozen_string_literal: true

module Types
    class NewPostInputType < Types::BaseInputObject
      argument :userId, ID
      argument :title, String
      argument :body, String
    end
  end
  