module Types
  class LoginType < Types::BaseObject
    description 'Login'
    field :git_data_user, String, null: false do
      argument :login, String, required: true
    end

    def git_data_user(login:)
      {
        name: get_name("https://api.github.com/users/#{login}"),
        repos: get_repos("https://api.github.com/users/#{login}/repos")
      }.to_json
    end

    private

    def get_data(requested_url)
      raise ArgumentError, 'Empty URL' if requested_url.blank?

      url = URI(requested_url)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(url)

      response = http.request(request)

      raise StandardError, "GitHub API request failed with code: #{response.code}" if response.code != '200'

      JSON.parse(response.body)
    end

    def get_name(requested_url)
      user_data = get_data(requested_url)
      user_data['name'] || 'Name not set'
    end

    def get_repos(requested_url)
      user_data = get_data(requested_url)
      user_data.map { |n| n['name'] }
    end
  end
end
