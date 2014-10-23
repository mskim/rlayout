require File.dirname(__FILE__) + "/../spec_helper"


# describe 'create TextLayoutManager' do
#   before do
#     # @att_string = {:fill_color=>'lightGray', :text_first_line_head_indent=>10, :text_paragraph_spacing_before=>10, :width=>200, :text_alignment=>'justified', :text_string=>"This is a paragraph test string and it looks good to me.", :markup=>'h6', :text_line_spacing=>10}
#     @g = Graphic.new(nil, proposed_height: 1000, text_string: "This is some sample string. And some more text is here.")
#     @pdf_path = File.dirname(__FILE__) + "/../output/text_layout_manager_test.pdf"
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

describe 'split TextLayoutManager' do
  before do
    # @att_string = {:fill_color=>'lightGray', :text_first_line_head_indent=>10, :text_paragraph_spacing_before=>10, :width=>200, :text_alignment=>'justified', :text_string=>"This is a paragraph test string and it looks good to me.", :markup=>'h6', :text_line_spacing=>10}
    @g = Graphic.new(nil, proposed_height: 100, text_string: "This is some sample string. And some more overflowing text.")
  end
  
  it 'should be text_overflow' do
    @g.text_layout_manager.text_overflow.must_equal true
  end
  
  it 'should split TextLayoutManager' do
    # @linked1_pdf_path = File.dirname(__FILE__) + "/../output/text_layout_manager_linked1_paragraph.pdf"
    # @g.save_pdf(@linked1_pdf_path)
    linked =@g.text_layout_manager.split_overflowing_paragraph
    linked.must_be_kind_of Paragraph
    puts "linked.class:#{linked.class}"
    puts "linked.text_layout_manager:#{linked.text_layout_manager}"
    @linked2_pdf_path = File.dirname(__FILE__) + "/../output/text_layout_manager_linked2_paragraph.pdf"
    linked.save_pdf(@linked2_pdf_path)
  end
  # 
  # it 'should save TextLayoutManager' do
  #   @g.save_pdf(@pdf_path)
  #   File.exists?(@pdf_path).must_equal true
  # end
end