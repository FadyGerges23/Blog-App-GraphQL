# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :sign_up_user, mutation: Mutations::SignUpUser
    field :sign_in_user, mutation: Mutations::SignInUser
    field :sign_out_user, mutation: Mutations::SignOutUser
    field :edit_user, mutation: Mutations::EditUser
    field :create_post, mutation: Mutations::CreatePost
    field :edit_post, mutation: Mutations::EditPost
    field :delete_post, mutation: Mutations::DeletePost
  end
end
