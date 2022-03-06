require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe "create RParagraph" do
  before do
    options                 = {}
    options[:para_string]        = 'This is a string.'
    options[:style_name]     = 'body'
    options[:create_para_lines]     = true
    @para = RParagraph.new(options)
    @first_token = @para.tokens.first
  end

  it 'should create RParagraph' do
    assert @para.class, RParagraph
  end


  it 'should create tokens' do
    assert @para.tokens.length,  4
  end

  it 'should create body_para_lines' do
    assert @para.lines.length,  1
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
