require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe "save r_text_token" do
  before do
    options                 = {}
    options[:string]        = '여기는'
    options[:string]        = 'Zöglings'
    @current_style_service  = RLayout::StyleService.shared_style_service
    @style_object = @current_style_service.style_object('body')
    options[:height]        = 20
    options[:parent]        = self
    options[:style_object]  = @style_object
    @t = RTextToken.new(options)
    options2                 = {}
    options2[:string]        = 'Zöglings'
    @style_object2 = @current_style_service.style_object('title')
    options2[:style_object]  = @style_object2
    @t2 = RTextToken.new(options2)
  end

  it 'should filter token string' do
    assert_equal @t.string, 'Zöglings'
  end

  it 'should filter token2 string' do
    assert @t2.has_missing_glyph
  end
end

__END__

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
