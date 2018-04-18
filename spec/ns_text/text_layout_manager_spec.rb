require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'text_string_array and text_atts_array' do
  before do
    @text_string_array  = ["This is a", "String"]
    @text_atts_array    = [{font_size:24, text_color: "red"}, {font_size:16, text_color: "CMYK=0,0,0,100"} ]
    @text               = Text.new(text_string_array: @text_string_array, text_atts_array: @text_atts_array)

  end

end

__END__


describe 'text overflow' do
  before do
    options = {
      width: 100,
      height: 50,
      font_size: 12,
      font: 'Times',
      text_line_spacing: 10,
      text_alignment: 'justified',
      text_string: "This is test. And this is the second paragraph. And some more sentence."*2,
      width: 250,
      text_fit_type:  1
    }
    @t = Text.new(options)
    @tl = @t.text_layout_manager
  end

  it 'should overflow' do
    @tl.must_be_kind_of TextLayoutManager
    @tl.text_overflow.must_equal true
  end

  it 'should save pdf' do
    @pdf_path = "/Users/Shared/rlayout/output/text_layout_fit_to_box.pdf"
    @tl.fit_text_to_box
    @t.save_pdf(@pdf_path)
    File.exist?(@pdf_path).must_equal true
    system("open #{@pdf_path}")
  end
end


describe 'dropcap' do
  before do
    drop_cap_options = {
      font_size: 12,
      font: 'Times',
      text_line_spacing: 10,
      text_alignment: 'justified',
      text_string: '끓여 내오신 라면은 정말 꿀맛이었다. 감사한 마음에 온갖 애교와 아양을 떨었다.
      “전국노래자랑 좋아하시는 걸보니 할머니께서도 예전엔 한가락 하셨을 것 같아요.” “그러믄. 왕년에 내가 노래 좀 했지.”
      어르신들은 누구나 자랑하고 싶은 ‘왕년에’가 있으신가보다.
       '*5,
       text_string: "This is a test and this is good"*5,

      drop_lines:  2,
      drop_font: 'Helvetica',
      drop_text_color: 'gray',
      width: 250
    }
    @t = Text.new(drop_cap_options)
    @tl = TextLayoutManager.new(@t, drop_cap_options)
  end
  it 'shluld create TextLayoutManager' do
    @tl.must_be_kind_of TextLayoutManager
  end

  it 'should save pdf' do
    @pdf_path = "/Users/Shared/rlayout/output/text_layout_manager_dropcap.pdf"
    @t.save_pdf(@pdf_path)
    File.exist?(@pdf_path).must_equal true
    system("open #{@pdf_path}")
  end
end

# describe 'create TextLayoutManager' do
#   before do
#     # @att_string = {:fill_color=>'lightGray', :text_first_line_head_indent=>10, :text_paragraph_spacing_before=>10, :width=>200, :text_alignment=>'justified', :text_string=>"This is a paragraph test string and it looks good to me.", :markup=>'h6', :text_line_spacing=>10}
#     @g = Graphic.new(proposed_height: 1000, text_string: "This is some sample string. And some more text is here.")
#     @pdf_path = "/Users/Shared/rlayout/output/text_layout_manager_test.pdf"
#   end
#
#   it 'should create TextLayoutManager' do
#     @g.text_layout_manager.must_be_kind_of TextLayoutManager
#   end
#
#   it 'should save TextLayoutManager' do
#     @g.save_pdf(@pdf_path)
#     File.exists?(@pdf_path).must_equal true
#   end
# end

# describe 'split TextLayoutManager' do
#   before do
#     # @att_string = {:fill_color=>'lightGray', :text_first_line_head_indent=>10, :text_paragraph_spacing_before=>10, :width=>200, :text_alignment=>'justified', :text_string=>"This is a paragraph test string and it looks good to me.", :markup=>'h6', :text_line_spacing=>10}
#     @g = Graphic.new(proposed_height: 100, text_string: "This is some sample string. And some more overflowing text.")
#   end
#
#
#   #
#   # it 'should save TextLayoutManager' do
#   #   @g.save_pdf(@pdf_path)
#   #   File.exists?(@pdf_path).must_equal true
#   # end
# end
