RSpec.describe ListFromGithubSchema do
  describe ListFromGithubSchema do
    describe 'resolve_type' do
      it 'raises GraphQL::RequiredImplementationMissingError' do
        abstract_type = double('abstract_type')
        obj = double('obj')
        ctx = double('ctx')

        expect do
          described_class.resolve_type(abstract_type, obj, ctx)
        end.to raise_error(GraphQL::RequiredImplementationMissingError)
      end
    end
  end

  describe ListFromGithubSchema do
    describe 'id_from_object' do
      it 'returns the global ID parameter of the object' do
        object = double('object', to_gid_param: 'test_global_id')
        type_definition = double('type_definition')
        query_ctx = double('query_ctx')

        expect(described_class.id_from_object(object, type_definition, query_ctx)).to eq('test_global_id')
      end
    end
  end

  describe ListFromGithubSchema do
    describe 'object_from_id' do
      it 'finds the object by global ID' do
        global_id = 'test_global_id'
        query_ctx = double('query_ctx')
        found_object = double('found_object')

        allow(GlobalID).to receive(:find).with(global_id).and_return(found_object)
        expect(described_class.object_from_id(global_id, query_ctx)).to eq(found_object)
      end
    end
  end
end
