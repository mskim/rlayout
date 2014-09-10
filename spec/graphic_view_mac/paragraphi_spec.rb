require File.dirname(__FILE__) + "/../spec_helper"

describe 'Paragraph creation test' do
  before do
    @para = Paragraph.new(nil, :text_string=>"This is a text", :markup=>"p")
    @path = File.dirname(__FILE__) + "/../output/text_drawing_test.pdf"
    # puts @para.inspect
  end
  
  it 'should create Pagragraph object' do
    @para.must_be_kind_of Paragraph
  end
  
  it 'shuld have attribute of text_string' do
    @para.text_string.must_equal "This is a text"
    @para.markup.must_equal "p"
    @para.text_size.must_equal 16
    @para.text_font.must_equal "Times"
    @para.text_color.must_equal "black"
  end
end

describe 'Paragraph line creation test' do
  before do
    @para = Paragraph.new(nil, :text_string=>"This is a text and I like it very very much lets see if you can layout this one.", :markup=>"p")
  end
  
  it 'should create Pagragraph object' do
    @para.must_be_kind_of Paragraph
  end
  
  it 'shuld have attribute of text_string' do
    @para.tokens.must_be_kind_of Array
    @para.tokens.first.text_string.must_equal "This"
    @para.tokens[1].height.must_equal 19
    # @para.tokens.each {|token| puts token.text_string}
  end
  
  it 'should not have any lines' do
    @para.graphics.length.must_equal 0
  end
  
end

describe 'Paragraph should change width and layout lines' do
  before do
    @para = Paragraph.new(nil, :text_string=>"This is a text and I like it very very much lets see if you can layout this one.", :markup=>"p")
    @para.change_width(300)
  end
  
  it 'should have lines' do
    @para.graphics.length.must_equal 2
    @para.graphics.each do |line|
      puts line.graphics.length
    end
  end
end

describe 'TextLine test' do
  before do
    @para = TextLine.new(nil)    
  end
  
  it 'should create TextLine object' do
    @para.must_be_kind_of TextLine
  end
  
end