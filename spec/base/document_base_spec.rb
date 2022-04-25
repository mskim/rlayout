require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'create StyleableDoc' do
  before do
    @document_base = "#{ENV["HOME"]}/test_data/document_base"
    FileUtils.mkdir_p(@document_base)  unless File.exist?(@document_base)
    @doc = StyleableDoc.new(document_base: @document_path)
  end

  it 'should create StyleableDoc' do
    assert_equal StyleableDoc, @doc.class
  end

  # it 'should create one line' do
  #   assert_equal 1, @graphics.length
  # end
end
