
require File.dirname(__FILE__) + "/../spec_helper"

describe 'create ParagrahJapanese' do
  before do
    @pj       = ParagraphJapanese.new(nil, text_string: "some japanese text")
    @pdf_path = File.dirname(__FILE__) + "/../output/paragraph_japanese.pdf"
  end
  
  it 'should create ParagraphJapanese' do
    @pj.must_be_kind_of ParagraphJapanese
  end
  
  it 'should have japanese settings' do
    @pj.text_direction.must_equal 'vertical'
    @pj.text_advancement.must_equal 'right_to_left'
    @pj.text_string.must_equal 'some japanese text'
    
  end
  
  it 'should have create vertival lines' do
    @pj.vertical_lines.must_be_kind_of Array
    @pj.vertical_lines.length.must_equal 6
  end
  
  # it 'should save pdf' do
  #   @pj.save_pdf(@pdf_path)
  # end
end