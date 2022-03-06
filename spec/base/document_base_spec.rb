require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'create StyleGuide' do
  before do
    @document_base = "/Users/mskim/test_data/document_base"
    FileUtils.mkdir_p(@document_base)  unless File.exist?(@document_base)
    @doc = StyleGuide.new(document_base: @document_path)
  end

  it 'should create StyleGuide' do
    assert_equal StyleGuide, @doc.class
  end

  # it 'should create one line' do
  #   assert_equal 1, @graphics.length
  # end
end
