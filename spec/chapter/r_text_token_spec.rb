require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe "create RTextToken" do
  before do
    options                 = {}
    options[:string]        = 'This'
    options[:style_name]     = 'body'
    @r_token = RTextToken.new(options)
  end

  it 'should create RTextToken' do
    @r_token.class.must_equal RTextToken
  end

  it 'should have style_name' do
    @r_token.style_name.must_equal 'body'
  end

  it 'should have style_name' do
    @r_token.width.must_equal 21.333984375
  end

  it 'should have hyphenate token' do
    result = @r_token.hyphenate_token(10.0)
    result.class.must_equal RTextToken
    @r_token.string.must_equal 'Th'
    result.string.must_equal 'is'
  end
end
