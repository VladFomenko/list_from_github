require 'rails_helper'

RSpec.describe GraphqlController, type: :controller do
  describe 'execute action' do
    it 'renders the execute template' do
      VCR.use_cassette('github_user_data') do
        login = 'VladFomenko'
        get :execute, params: { login: 'VladFomenko' }
        expect(response).to render_template(:execute)
        expect(controller.send(:graphql_params)[:login]).to eq(login)
      end
    end

    it 'handles errors in development mode' do
      error_message = 'Test error message'
      allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new('development'))
      expect(controller).to receive(:handle_error_in_development).with(an_instance_of(StandardError))

      allow(ListFromGithubSchema).to receive(:execute).and_raise(StandardError, error_message)
      get :execute
    end
  end

  describe '#prepare_variables' do
    let(:controller_instance) { GraphqlController.new }

    it 'parses string parameters correctly' do
      variables_param = '{"key": "value"}'
      parsed_result = controller_instance.send(:prepare_variables, variables_param)

      expect(parsed_result).to eq({ 'key' => 'value' })
    end

    it 'handles empty string parameter' do
      variables_param = ''
      parsed_result = controller_instance.send(:prepare_variables, variables_param)

      expect(parsed_result).to eq({})
    end

    it 'returns the hash parameter as is' do
      variables_param = { key: 'value' }
      parsed_result = controller_instance.send(:prepare_variables, variables_param)

      expect(parsed_result).to eq(variables_param)
    end

    it 'returns ActionController::Parameters as unsafe hash' do
      parameters = ActionController::Parameters.new(key: 'value')
      parsed_result = controller_instance.send(:prepare_variables, parameters)

      expect(parsed_result).to eq({ 'key' => 'value' })
    end

    it 'returns empty hash for nil parameter' do
      parsed_result = controller_instance.send(:prepare_variables, nil)

      expect(parsed_result).to eq({})
    end

    it 'raises ArgumentError for unexpected parameter' do
      expect do
        controller_instance.send(:prepare_variables, 123)
      end.to raise_error(ArgumentError, 'Unexpected parameter: 123')
    end
  end

  describe '#handle_error_in_development' do
    let(:controller_instance) { GraphqlController.new }

    it 'logs error message and backtrace, sets flash and renders new with internal server error status' do
      error_message = 'An error occurred'
      backtrace = ['line 1', 'line 2']

      expected_flash_message = "An error occurred: #{error_message}"
      expected_response = { error: expected_flash_message }

      expect(controller_instance).to receive(:logger).twice.and_return(logger = double('Logger'))
      expect(logger).to receive(:error).with(error_message)
      expect(logger).to receive(:error).with(backtrace.join("\n"))

      allow(controller_instance).to receive_message_chain(:request, :flash).and_return({})
      expect(controller_instance).to receive(:render).with('new', status: :internal_server_error)

      controller_instance.send(:handle_error_in_development, StandardError.new(error_message).tap do |e|
        e.set_backtrace(backtrace)
      end)

      expect(controller_instance.flash[:error]).to eq(expected_flash_message)
    end
  end


end
