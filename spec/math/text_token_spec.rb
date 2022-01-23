require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'create LineFragment' do
  before do
    @text_column  = TextColumn.new({})
    @text_column.create_grid_rects
    @tm           = Paragraph.new(para_string: "this is a test string")
    @tm.layout_lines(@text_column)
    @line         = @tm.lines.first
  end
  
  it 'should create LineFragment' do
    assert @line.class == RLayout::LineFragment
    assert @tm.line_count == 1
  end
  
  it 'should create tokes' do
    assert @line.tokens.length == 5
  end
  
  it 'should have TextTokens as tokens element' do
    assert @line.tokens.first.class == TextToken
    assert @line.tokens.last.class == TextToken
  end
  
  it 'should have LineFragment style' do
    assert @line.tokens.first.string == "this"
    assert @line.tokens[1].string == "is"
    assert @line.tokens[2].string == "a"
    assert @line.tokens[3].string == "test"
    assert @line.tokens[4].string == "string"
  end
end

__END__


describe 'create Paragraph' do
  before do
    @tm = Paragraph.new(para_string: "this is a test string "*5, width: 200, height: 500)
  end
  
  it 'shuld create Paragraph' do
    assert @tm.class == Paragraph
  end
    
  it 'should have default para_style' do
    assert @tm.para_style[:font]        == 'Times'
    assert @tm.para_style[:size]        == 10
    assert @tm.para_style[:h_alignment] == "left"
    assert @tm.para_style[:v_alignment] == "center"
  end
end


describe 'create TextToken' do
  before do
    @tt = TextToken.new("this", {})
  end
  
  it 'should create TextToken' do
    assert @tt.class == TextToken
  end
  
  it 'should have string' do
    assert @tt.string == 'this'
    assert @tt.x == 0
    assert @tt.y == 0
  end
end


describe 'create Paragraph with h_alignment' do
  
  it 'shuld h_alignment left' do
    para_style = {h_alignment: "left"}
    @tm = Paragraph.new(para_string: "this is a test string "*5, width: 200, height: 500, para_style: para_style)
    assert @tm.para_style[:h_alignment] == "left"
  end
  
  it 'shuld h_alignment center' do
    para_style = {h_alignment: "center"}
    @tm = Paragraph.new(para_string: "this is a test string "*5, width: 200, height: 500, para_style: para_style)
    assert @tm.para_style[:h_alignment] == "center"
  end
  
  it 'shuld h_alignment right' do
    para_style = {h_alignment: "right"}
    @tm = Paragraph.new(para_string: "this is a test string "*5, width: 200, height: 500, para_style: para_style)
    assert @tm.para_style[:h_alignment] == "right"
  end
  
  it 'shuld h_alignment justify' do
    para_style = {h_alignment: "justify"}
    @tm = Paragraph.new(para_string: "this is a test string "*5, width: 200, height: 500, para_style: para_style)
    assert @tm.para_style[:h_alignment] == "justify"
  end
  
end



