class GitHubController < ApplicationController
  include GithubQuery

  before_action :git_gub_params, only: :show

  def show
    response = Github::Client.query(GithubQuery::QueryString, variables: { login: params[:login] })

    @user_data = parse_response(response)
  rescue StandardError
    flash.now[:error] = response.original_hash['errors'].map { |error| error['message'] }
    render :new
  end

  def new
    flash.now[:error] = nil
  end

  private

  def parse_response(response)
    result = { name: '', repo: [] }
    result[:name] = response.data.user.name.present? ? response.data.user.name : 'Unknown'

    repositories = response.data.user.repositories.nodes

    repositories.each do |repo|
      result[:repo] << repo.name
    end

    result
  end

  def git_gub_params
    params.permit(:login)
  end
end
