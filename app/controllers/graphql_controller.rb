class GraphqlController < ApplicationController
  include Constantable

  before_action :set_login, only: :execute

  def new; end

  def execute
    variables = prepare_variables(login: @login)
    query = QUERY

    result = ListFromGithubSchema.execute(query, variables:)
    @user_data = JSON.parse(result['data']['gitDataUser'])

  rescue StandardError => e
    handle_error_in_development(e)
  end

  private

  def prepare_variables(variables_param)
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    flash[:error] = "An error occurred: #{e.message}"
    render 'new', status: :internal_server_error
  end

  def set_login
    @login = params[:login]
  end

  def graphql_params
    params.permit(:login)
  end
end
