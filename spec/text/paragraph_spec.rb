
require File.dirname(__FILE__) + "/../spec_helper"

describe 'ParagraphModel creation' do
  before do
    @pm = ParagraphModel.new
  end
  
  it 'should create ParagraphModel' do
    @pm.must_be_kind_of ParagraphModel
  end
  
  it 'should have markpu' do
    @pm.markup.must_equal 'p'
    @pm.string.must_equal ''
  end
end

# NSTextAlignmentLeft       = 0,
# NSTextAlignmentCenter     = 1,
# NSTextAlignmentRight      = 2,
# NSTextAlignmentJustified  = 3,
# NSTextAlignmentNatural    = 4,


describe 'create Paragraph' do
  before do
    options = {:fill_color=>'lightGray', :text_first_line_head_indent=>10, :text_paragraph_spacing_before=>10, :width=>200, :text_alignment=>'justified', :text_string=>"This is a paragraph test string and it looks good to me.", :markup=>'h6', :text_line_spacing=>10}
    @para = Paragraph.new(nil, options)
  end
    
  it 'should create Paragraph' do
    @para.x.must_equal 0
    # @para.y.must_equal 0
    @para.width.must_equal 200
    if RUBY_ENGINE == 'macruby'
      @para.height.must_equal 100
    else
      @para.height.must_equal 100
    end
    @para.must_be_kind_of Paragraph
  end
  
  it 'should save paragraph' do
    pdf_path = File.dirname(__FILE__) + "/../output/paragraph_test.pdf"
    @para.save_pdf(pdf_path)
  end
end

# describe 'create ParagraphJ' do
#   before do
#     @pj       = Paragraph.new(nil, inset:50, width: 400, height: 600, text_direction: 'top_to_bottom', text_size:12, text_string:  "しかし、これは非常に複雑で、広範囲であるために一般的に使用するには無理が伴います。SGMLの規則によりながら、Webに使用するいくつかのマークアップのみを定義して使用したものがHTMLです。")
#     @pdf_path = File.dirname(__FILE__) + "/../output/paragraph_japanese.pdf"
#   end
#   
#   it 'should create ParagraphJ' do
#     @pj.must_be_kind_of Paragraph
#   end
#   
#   it 'should have japanese settings' do
#     @pj.text_direction.must_equal 'top_to_bottom'
#     # @pj.text_advancement.must_equal 'right_to_left'
#     # @pj.text_string.must_equal 'some japanese text'
#   end
#   it 'should save paragraphj' do
#     @pj.save_pdf(@pdf_path)
#   end
#   
# end
