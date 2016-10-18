
require 'minitest/autorun'
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '../..', 'lib')
require 'rlayout/graphic'
require 'rlayout/container'
require 'rlayout/style/style_service'
require 'rlayout/text/paragraph'
include RLayout


# NSTextAlignmentLeft       = 0,
# NSTextAlignmentCenter     = 1,
# NSTextAlignmentRight      = 2,
# NSTextAlignmentJustified  = 3,
# NSTextAlignmentNatural    = 4,


describe 'create Paragraph' do
  before do
    options = {:fill_color=>'lightGray', :text_first_line_head_indent=>10, :text_paragraph_spacing_before=>10, :width=>200, :text_alignment=>'justified', :text_string=>"This is a paragraph test string and it looks good to me.", :markup=>'h6', :text_line_spacing=>10}
    @para = Paragraph.new(options)
  end
    
  it 'should create Paragraph' do
    @para.x.must_equal 0
    # @para.y.must_equal 0
    @para.width.must_equal 200
    @para.height.must_equal 100    
    @para.must_be_kind_of Paragraph
  end
  
  it 'should save paragraph' do
    @svg_path = "/Users/Shared/rlayout/output/paragraph_test.svg"
    @para.save_svg(@svg_path)
    system("open #{@svg_path}")
  end
end
