# frozen_string_literal: true

module Constantable
  extend ActiveSupport::Concern

  QUERY = <<~GRAPHQL
    query($login: String!) {
      gitDataUser(login: $login)
    }
  GRAPHQL
end
