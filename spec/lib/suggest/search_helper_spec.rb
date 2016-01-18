require 'rails_helper'

describe Pulmap::Suggest::SearchHelper do
  class SearchHelperTestClass
    include Pulmap::Suggest::SearchHelper

    attr_accessor :blacklight_config
    attr_accessor :repository

    def initialize blacklight_config, conn
      self.blacklight_config = blacklight_config
      self.repository = Blacklight::SolrRepository.new(blacklight_config)
      self.repository.connection = conn
    end

    def params
      {}
    end
  end

  subject { SearchHelperTestClass.new blacklight_config, blacklight_solr }

  let(:blacklight_config) { Blacklight::Configuration.new }
  let(:copy_of_catalog_config) { ::CatalogController.blacklight_config.deep_copy }
  let(:blacklight_solr) { RSolr.connect(Blacklight.connection_config) }

  describe '#get_suggestions' do
    it 'returns a Pulmap::Suggest::Response' do
      expect(subject.get_suggestions q: 'test').to be_an Pulmap::Suggest::Response
    end
  end
  describe '#suggest_results' do
    it 'queries the suggest handler with params' do
      allow(blacklight_solr).to receive(:get) do |path, params|
        expect(path).to eq 'suggest'
        expect(params).to eq params: { q: 'pr' }
      end
      subject.query_solr q: 'pr'
    end
  end
end
