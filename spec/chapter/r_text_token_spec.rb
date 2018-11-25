require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe "FORBIDDEN_FIRST_CHARS_AT_END test" do
  before do
    options                 = {}
    options[:string]        = 'Th)'
    @current_style          = RLayout::StyleService.shared_style_service.current_style
    @para_style             = @current_style['body']
    options[:para_style]    = @para_style
    @r_token = RTextToken.new(options)
  end

  it 'should create RTextToken' do
    @r_token.class.must_equal RTextToken
  end

  it 'should have style_name' do
    @r_token.style_name.must_equal 'body'
  end

  it 'should have hyphenate token' do
    result = @r_token.hyphenate_token(15.0)
    result.class.must_equal String
    result.must_equal "front forbidden character"
  end
end

describe "FORBIDDEN_FIRST_CHARS at firtt char of second string" do
  before do
    options                 = {}
    options[:string]        = 'Thi)s'
    @current_style          = RLayout::StyleService.shared_style_service.current_style
    @para_style             = @current_style['body']
    options[:para_style]    = @para_style    @r_token = RTextToken.new(options)
  end

  it 'should create RTextToken' do
    @r_token.class.must_equal RTextToken
  end

  it 'should have style_name' do
    @r_token.style_name.must_equal 'body'
  end

  it 'should have hyphenate token' do
    result = @r_token.hyphenate_token(15.0)
    result.class.must_equal RTextToken
    @r_token.string.must_equal 'Th'
    result.string.must_equal 'i)s'
  end
end

describe "FORBIDDEN_LAST_CHARS at front_string[-2]" do
  before do
    options                 = {}
    options[:string]        = 'Th(is'
    @current_style          = RLayout::StyleService.shared_style_service.current_style
    @para_style             = @current_style['body']
    options[:para_style]    = @para_style    @r_token = RTextToken.new(options)
  end

  it 'should create RTextToken' do
    @r_token.class.must_equal RTextToken
  end

  it 'should have hyphenate token' do
    result = @r_token.hyphenate_token(15.0)
    result.class.must_equal RTextToken
    @r_token.string.must_equal 'Th'
    result.string.must_equal '(is'
  end
end
