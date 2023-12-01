class GitHubController < ApplicationController
  include GithubQuery

  def index
    response = Github::Client.query(GithubQuery::QueryString, variables: { login: 'VladFomenko' })

    @user_data = parse_response(response)
  end

  private

  def parse_response(response)
    result = { name: '', repo: [] }
    result[:name] = response.data.user.name.present? ? "Name: #{response.data.user.name}" : 'Name: Unknown'

    repositories = response.data.user.repositories.nodes

    repositories.each do |repo|
      result[:repo] << repo.name
    end

    result
  end
end
