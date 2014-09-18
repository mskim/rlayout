require File.dirname(__FILE__) + "/../spec_helper"

describe 'Paragraph creation test' do
  before do
    @para = Paragraph.new(nil, :para_string=>"One Two Three Four Five Six Seven Eight Nine Ten Eleven Twelve Thirteen Fourteen", :markup=>"p")    
  end
  
  it 'should create Pagragraph object' do
    @para.must_be_kind_of Paragraph
  end
  
  it 'shuld have attribute of para_string' do
    @para.para_string.must_equal "One Two Three Four Five Six Seven Eight Nine Ten Eleven Twelve Thirteen Fourteen"
    @para.markup.must_equal "p"
    @para.text_size.must_equal 12
    @para.text_font.must_equal "Times"
    @para.text_color.must_equal "black"
  end
  
  if RUBY_ENGINE == 'macruby'
    it 'should save pdf' do
      @para.change_width_and_adjust_height(300)
      # puts "@para.inspect:#{@para.inspect}"
      @pdf_path = File.dirname(__FILE__) + "/../output/paragraph_test.pdf"
      @para.save_pdf(@pdf_path)
      File.exists?(@pdf_path).must_equal true
      system "open #{@pdf_path}"
    end
  end
end

describe 'Paragraph line creation test' do
  before do
    @para = Paragraph.new(nil, :para_string=>"This is a text and I like it very very much lets see if you can layout this one.", :markup=>"p")
  end
  
  it 'should create Pagragraph object' do
    @para.must_be_kind_of Paragraph
  end
  
  it 'shuld have attribute of text_string' do
    @para.tokens.must_be_kind_of Array
    # @para.tokens[1].height.must_equal 22
    # @para.tokens.each {|token| puts token.text_string}
  end
  
  it 'should not have any lines' do
    @para.graphics.length.must_equal 0
  end
  
end

describe 'Paragraph should change width and layout lines' do
  before do
    @para = Paragraph.new(nil, :para_string=>"This is a text and I like it very very much lets see if you can layout this one.", :markup=>"p")
    @para.change_width_and_adjust_height(300)
    @path = File.dirname(__FILE__) + "/../output/paragraph_test.svg"
    
  end
  
  it 'should have lines' do
    @para.graphics.length.must_equal 2
    @para.save_svg(@path)
    File.exists?(@path).must_equal true
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