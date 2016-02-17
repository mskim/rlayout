# require File.dirname(__FILE__) + "/../spec_helper"
# 
# describe 'text_drawing test' do
#   before do
#     @t = Text.new(nil, :text_string=> "This is a text", :text_alignment=>"center")
#     @path = "/Users/Shared/rlayout/output/text_drawing_test.pdf"
#   end
#   
#   it 'should create Text object' do
#     @t.must_be_kind_of Text
#   end
#   
#   it 'shuld have attribute of text_string' do
#     @t.text_string.must_equal "This is a text"
#     @t.text_size.must_equal 16
#     @t.font.must_equal "Times"
#     @t.text_color.must_equal "black"
#   end
#   
#   it 'should draw text' do
#     @t.save_pdf(@path)
#   end
# end