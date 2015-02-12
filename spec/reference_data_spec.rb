require 'spec_helper'

describe 'ReferenceData API' do
  include_context 'configuration'

  it 'lists all' do
    VCR.use_cassette('reference_data_list_all') do
      all = StartupLoan::ReferenceData.find(client)
      found_reference_type_names = all.inject([]) do|a, rd|
        a << rd.reference_type_name
      end
      expect(found_reference_type_names).to match_array(reference_type_names)
    end
  end

  it 'filters the list' do
    VCR.use_cassette('reference_data_list_filtered') do
      filtered = StartupLoan::ReferenceData.find(client, type: reference_type_names.first)
      expect(filtered.count).to be 1
      expect(filtered.first.reference_type_name).to eql reference_type_names.first
    end
  end

  it 'prevents adding' do
    expect do
      new_ref_data = StartupLoan::ReferenceData.new(client, reference_type_name: 'foobar')
      new_ref_data.save
    end.to raise_error(StartupLoan::NotSupported)
  end

  it 'prevents updating' do
    VCR.use_cassette('reference_data_prevent_update') do
      filtered = StartupLoan::ReferenceData.find(client, type: reference_type_names.first)
      reference_data_item = filtered.first
      reference_data_item.description = 'hello world'
      expect(reference_data_item.dirty?).to be true
      expect do
        reference_data_item.save
      end.to raise_error(StartupLoan::NotSupported)
    end
  end
end
