# frozen_string_literal: true

module GithubQuery
  extend ActiveSupport::Concern

  QueryString = Github::Client.parse <<~GRAPHQL
    query($login: String!) {
      user(login: $login) {
        name,
        repositories(first: 10) {
          nodes {
            name
          }
        }
      }
    }
  GRAPHQL
end
