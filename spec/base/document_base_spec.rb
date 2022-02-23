require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'create DocumentBase' do
  before do
    @document_base = "/Users/mskim/test_data/document_base"
    FileUtils.mkdir_p(@document_base)  unless File.exist?(@document_base)
    @doc = DocumentBase.new(document_base: @document_path)
  end

  it 'should create DocumentBase' do
    assert_equal DocumentBase, @doc.class
  end

  # it 'should create one line' do
  #   assert_equal 1, @graphics.length
  # end
end
