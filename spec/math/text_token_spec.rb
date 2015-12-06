require File.dirname(__FILE__) + "/../spec_helper"

describe 'crate RTextLayoutManager with h_alignment' do
  
  it 'shuld h_alignment left' do
    @tm = RTextLayoutManager.new(nil, text_string: "this is a test string "*5, width: 200, height: 500, h_alignment: "left")
    assert @tm.para_style.h_alignment == "left"
  end
  
  it 'shuld h_alignment center' do
    @tm = RTextLayoutManager.new(nil, text_string: "this is a test string "*5, width: 200, height: 500, h_alignment: "center")
    assert @tm.para_style.h_alignment == "center"
  end
  
  it 'shuld h_alignment right' do
    @tm = RTextLayoutManager.new(nil, text_string: "this is a test string "*5, width: 200, height: 500, h_alignment: "right")
    assert @tm.para_style.h_alignment == "right"
  end
  
  it 'shuld h_alignment justified' do
    @tm = RTextLayoutManager.new(nil, text_string: "this is a test string "*5, width: 200, height: 500, h_alignment: "justified")
    assert @tm.para_style.h_alignment == "justified"
  end
  
end


describe 'create RTextLayoutManager' do
  before do
    @tm = RTextLayoutManager.new(nil, text_string: "this is a test string "*5, width: 200, height: 500)
  end
  
  it 'shuld create RTextLayoutManager' do
    assert @tm.class == RTextLayoutManager
  end
  
  it 'should create text_container' do
    @text_container  = @tm.text_container
    assert @text_container.width    == 200
    assert @text_container.height   == 500
    assert @text_container.text_layout_manager == @tm
  end
  
  it 'should have default para_style' do
    assert @tm.para_style[:font]        == 'Times'
    assert @tm.para_style[:size]        == 12
    assert @tm.para_style[:h_alignment] == "left"
    assert @tm.para_style[:v_alignment] == "center"
  end
end

describe 'create LineFragment' do
  before do
    @tm = RTextLayoutManager.new(nil, text_string: "this is a test string "*3)
    @line = @tm.text_container.lines.first
  end
  
  it 'should create LineFragment' do
    assert @line.class == LineFragment
    assert @tm.line_count == 1
  end
  
  it 'should create tokes' do
    assert @line.line_tokens.length == 15
  end
  
  it 'should have TextTokens as line_tokens element' do
    assert @line.line_tokens.first.class == TextToken
    assert @line.line_tokens.last.class == TextToken
  end
  
  it 'should have LineFragment style' do
    assert @line.line_tokens.first.string == "this"
    assert @line.line_tokens[1].string == "is"
  end
end

describe 'create TextToken' do
  before do
    @tt = TextToken.new("this", 0, 0, 100, 20)
  end
  
  it 'should create TextToken' do
    assert @tt.class == TextToken
  end
  
  it 'should have string' do
    assert @tt.string == 'this'
    assert @tt.x      == 0
    assert @tt.y      == 0
    assert @tt.width  == 100
    assert @tt.height == 20
  end
end
