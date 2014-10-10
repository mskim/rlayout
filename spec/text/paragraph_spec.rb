
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
    options = {:width=>200, :text_alignment=>'justified', :text_string=>"This is a paragraph test string and it looks good to me.", :markup=>'body', :text_line_spacing=>10}
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

