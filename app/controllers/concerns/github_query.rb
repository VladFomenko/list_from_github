# frozen_string_literal: true

module GithubQuery
  extend ActiveSupport::Concern

  QueryString = Github::Client.parse <<~GRAPHQL
        query($login: String!, $pageSize: Int!, $cursor: String) {
          user(login: $login) {
            name,
        repositories(first: $pageSize, after: $cursor) {
          edges {
            node {
              name
            }
            cursor
          }
          pageInfo {
            hasNextPage
            endCursor
            startCursor
          }
        }
      }
    }
  GRAPHQL
end
