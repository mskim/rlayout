
require 'minitest/autorun'
include RLayout

describe 'create TextLayoutManager' do
  before do
    # @att_string = {:fill_color=>'lightGray', :text_first_line_head_indent=>10, :text_paragraph_spacing_before=>10, :width=>200, :text_alignment=>'justified', :text_string=>"This is a paragraph test string and it looks good to me.", :markup=>'h6', :text_line_spacing=>10}
    options = {}
    options[:text_string]     = "This is some sample string."
    options[:text_direction]     = "left_to_right"
    @text_container = [0,0,300,200]
    @tlm = TextLayoutManager.new(@text_container, options)
  end
  
  it 'should create TextLayoutManager' do
    @tlm.must_be_kind_of TextLayoutManager
  end
  
  # it 'should create TextTokens' do
  #   @tlm.token_list.must_be_kind_of Array
  #   @tlm.token_list.length.must_equal 10
  #   @tlm.token_list.each do |token|
  #     puts token.inspect
  #   end
  # end
  
end