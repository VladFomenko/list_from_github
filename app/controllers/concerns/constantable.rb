# frozen_string_literal: true

module Constantable
  extend ActiveSupport::Concern

  PAGE_SIZE = 16
  QUERY = <<~GRAPHQL
    query($login: String!) {
      gitDataUser(login: $login)
    }
  GRAPHQL

  # TODO: upd query
  # QueryString = <<~GRAPHQL
  #       query($login: String!, $pageSize: Int!, $cursor: String) {
  #         user(login: $login) {
  #           name,
  #       repositories(first: $pageSize, after: $cursor) {
  #         edges {
  #           node {
  #             name
  #           }
  #           cursor
  #         }
  #         pageInfo {
  #           hasNextPage
  #           endCursor
  #           startCursor
  #         }
  #       }
  #     }
  #   }
  # GRAPHQL
end
