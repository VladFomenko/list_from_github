class GitHubController < ApplicationController
  include GithubQuery
  include Validatable

  before_action :git_gub_params, :set_login, :set_has_next_page, :set_end_cursor, :set_start_cursor, :logic_pagi, only: :show

  def show
    @user_data = parse_response(@response)
  rescue StandardError
    flash.now[:error] = @response.original_hash['errors'].map { |error| error['message'] }
    render :new
  end

  def new
    flash.now[:error] = nil
  end

  private

  def parse_response(response)
    result = { name: '', repo: [] }
    result[:name] = response.data.user.name.present? ? response.data.user.name : ISNT_SET_NAME_USER

    repositories = response.data.user.repositories.edges

    repositories.each do |repo|
      result[:repo] << repo.node.name
    end

    result
  end

  def set_login
    @login = params[:login]
  end

  def set_has_next_page
    @has_next_page = params[:has_next_page]
  end

  def set_end_cursor
    @end_cursor = params[:end_cursor]
  end

  def set_start_cursor
    @start_cursor = params[:start_cursor]
  end

  def logic_pagi
    if @has_next_page.nil?
      @response = query(@login, PAGE_SIZE, nil)
    elsif @end_cursor && @has_next_page
      @response = query(@login, PAGE_SIZE, @end_cursor)
    elsif @start_cursor
      @response = query(@login, PAGE_SIZE, @start_cursor)
    end

    return unless @response.original_hash['errors'].nil? || @response.original_hash['errors'][0]['message'].nil?

    @has_next_page = @response.original_hash['data']['user']['repositories']['pageInfo']['hasNextPage']
    @end_cursor = @response.original_hash['data']['user']['repositories']['pageInfo']['endCursor']
    @start_cursor = @response.original_hash['data']['user']['repositories']['pageInfo']['startCursor']

  end

  def query(login, page_size = PAGE_SIZE, cursor = nil)
    @response = Github::Client.query(GithubQuery::QueryString, variables: { login: login, pageSize: page_size, cursor: cursor })
  end

  def git_gub_params
    params.permit(:login, :has_next_page, :end_cursor, :start_cursor)
  end
end
