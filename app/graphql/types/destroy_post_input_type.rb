# frozen_string_literal: true

module Types
    class DestroyPostInputType < Types::BaseInputObject
      argument :userId, ID
      argument :postId, ID
    end
  end