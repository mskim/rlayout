require File.dirname(__FILE__) + "/../spec_helper"

describe 'testing heading block' do
  before do
    @t = Text.new(nil, width: 400,  text_string: "This is text string and I like it very much. Wouldn't you? "*4, text_size: 24, text_alignment: 'left')
  end
  
  it 'should create heading' do
    @t.must_be_kind_of Text
    @t.text_size.must_equal 24
  end
  
  it 'should save Text' do
    @svg_path = File.dirname(__FILE__) + "/../output/text_test.svg"
    @pdf_path = File.dirname(__FILE__) + "/../output/texxt_test.pdf"
    @t.save_svg(@svg_path)
    File.exists?(@svg_path).must_equal true
    @t.save_pdf(@pdf_path)
    File.exists?(@pdf_path).must_equal true
  end
  
end