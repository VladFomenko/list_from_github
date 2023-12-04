require 'rails_helper'

RSpec.describe GitHubController, type: :controller do
  describe 'GET #show' do
    it 'renders the show template' do
      VCR.use_cassette('github_user_data') do
        get :show, params: { login: 'test_user' }
        expect(response).to render_template(:show)
      end
    end

    it 'fetches user data from GitHub API' do
      VCR.use_cassette('github_user_data') do
        get :show, params: { login: 'test_user' }
        expect(assigns(:user_data)).to eq({ name: 'Vladyslav Fomenko',
                                            repo: %w[RubyHW ror_geekhub_jira ror_geekhub_jira hospital_control api
                                                     test_deploy_netlify] })
      end
    end
  end

  describe 'GET #new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe '#show' do
    it 'gets user data from GitHub' do
      VCR.use_cassette('github_user_data') do
        get :show, params: { login: 'test_user' }
        expect(response).to be_successful
      end
    end
  end
end
