require 'spec_helper'
class MockModel < StartupLoan::BaseModel;  end
class MockAccessorModel < StartupLoan::BaseModel; attr_accessor :description; end
describe 'base_model' do
  include_context 'configuration'
  let(:attributes) { { id: 1, name: 'dummy name' } }
  let(:mock_model) { MockModel.new(client, attributes, true) }
  describe 'Attributes' do
    it 'has a client instance' do
      expect(mock_model.connection.class).to eq StartupLoan::Client
    end

    it 'raises method missing' do
       expect { mock_model.foo_bar }.to raise_error
    end

    it 'sets accessor rather than using method missing if accessor exists' do
      expect_any_instance_of(MockAccessorModel).to receive(:description=)
      obj = MockAccessorModel.new(client, attributes)
      obj.set_all_attributes({description:"foo bar"})
    end
    it 'clears all dirty flags' do
      mock_model.name = "updated name"
      expect(mock_model.dirty?).to be true
      mock_model.clear_dirty_flags
      expect(mock_model.dirty?).to be false
    end
    it 'has access to attribute' do
      expect(mock_model.id).to eq attributes[:id]
    end

    it 'has can set an existing attribute' do
      mock_model.name = 'foobar'
      expect(mock_model.name).to eq 'foobar'
    end

    it 'has no changed attribtues ' do
      expect(mock_model.dirty?).to eq false
    end

    it 'has changed attribtues ' do
      mock_model.name = 'foobar'
      expect(mock_model.dirty?).to eq true
    end

    it 'finds changed attribtues' do
      mock_model.name = 'foobar'
      expect(mock_model.get_dirty_attributes.keys.include?('name')).to eq true
      expect(mock_model.get_dirty_attributes.keys.include?('id')).to eq false
    end
  end
end
