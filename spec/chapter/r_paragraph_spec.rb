require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe "create RParagraph" do
  before do
    options                 = {}
    options[:para_string]        = 'This is a string.'
    options[:style_name]     = 'body'
    @para = RParagraph.new(options)
    @first_token = @para.tokens.first
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

  it 'should have RToken class' do
    @first_token.must_be_kind_of RTextToken
  end
end

# describe "layout lines" do
#   before do
#     @col = RColumn.new()
#     @first_line = @col.first_line
#     options                  = {}
#     options[:para_string]    = 'This is a string. '*3
#     options[:style_name]     = 'body'
#     @para = RParagraph.new(options)
#     @para.layout_lines(@first_line)
#   end

#   it 'should layout in first line' do
#     @first_line.graphics.length.must_equal 11
#   end
# end

# describe "layout body_gothic lines" do
#   before do
#     @col = RColumn.new()
#     @first_line = @col.first_line
#     options                  = {}
#     options[:para_string]    = 'This is a string. '*3
#     options[:style_name]     = 'body_gothic'
#     @para = RParagraph.new(options)
#     @para.layout_lines(@first_line)
#   end

#   it 'should layout in first line' do
#     @first_line.graphics.length.must_equal 11
#   end
# end
