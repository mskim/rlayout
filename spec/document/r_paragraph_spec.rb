require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"
describe "create bold tokens" do
  before do
    options                 = {}
    options[:para_string] = 'This *italic* and $\frac{a}{b}$ **is a bold string**.'
    options[:style_name] = 'body'
    @para = RParagraph.new(options)
    @first_token = @para.tokens.first
    @second_token = @para.tokens[1]
    @fourth_token = @para.tokens[3]
    @last_token = @para.tokens.last
  end

  it 'should create RParagraph' do
    assert @first_token.token_type, 'plain'
    assert @second_token.token_type, 'italic'
    assert @second_token.token_type, 'math'
    assert @last_token.token_type, 'bold'
  end
end


describe "create RParagraph" do
  before do
    options = {}
    options[:para_string] = 'This is a string.'
    options[:style_name] = 'body'
    @para = RParagraph.new(options)
    @first_token = @para.tokens.first
  end

  it 'should create RParagraph' do
    assert @para.class, RParagraph
  end


  it 'should create tokens' do
    assert @para.tokens.length,  4
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
