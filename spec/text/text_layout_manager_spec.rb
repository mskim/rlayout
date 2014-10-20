require File.dirname(__FILE__) + "/../spec_helper"


describe 'create TextLayoutManager' do
  before do
    # @att_string = {:fill_color=>'lightGray', :text_first_line_head_indent=>10, :text_paragraph_spacing_before=>10, :width=>200, :text_alignment=>'justified', :text_string=>"This is a paragraph test string and it looks good to me.", :markup=>'h6', :text_line_spacing=>10}
    @g = Graphic.new(nil, text_string: "This is some sample string.")
  end
  
  it 'should create TextLayoutManager' do
    @g.text_layout_manager.must_be_kind_of TextLayoutManager
  end
  
  # it 'should create TextTokens' do
  #   @tlm.token_list.must_be_kind_of Array
  #   @tlm.token_list.length.must_equal 10
  #   @tlm.token_list.each do |token|
  #     puts token.inspect
  #   end
  # end
  
end