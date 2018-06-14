require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe "create RParagraph" do
  before do
    options                 = {}
    options[:string]        = 'This is a string.'
    options[:style_name]     = 'body'
    @para = RParagraph.new(options)
  end

  it 'should create RParagraph' do
    @para.must_be_kind_of RParagraph
  end

  it 'should have style_name' do
    @para.style_name.must_equal 'body'
  end

  it 'should create tokens' do
    @para.tokens.length.must_equal 4
  end

end
