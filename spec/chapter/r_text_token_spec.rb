require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe "save r_text_token" do
  before do
    options                 = {}
    options[:string]        = '여기는'
    @c = RLayout::Container.new(width:400, height:400, fill_color: 'yellow') do
      options                 = {}
      options[:string]        = '여기는'
      @current_style          = RLayout::StyleService.shared_style_service.current_style
      if @current_style.class == String
        @current_style        = YAML::load(@current_style)
      end
      @para_style             = @current_style['body']
      @para_style             = Hash[@para_style.map{ |k, v| [k.to_sym, v] }]
      options[:para_style]    = @para_style
      options[:height]        = 20
      options[:parent]        = self
      RTextToken.new(options)
    end
    @pdf_path = "/Users/Shared/rlayout/output/r_text_token_test.pdf"
  end

  it 'should save pdf' do
    @c.save_pdf(@pdf_path)
    File.exist?(@pdf_path).must_equal true
    system("open #{@pdf_path}")
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
