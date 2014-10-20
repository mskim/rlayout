# 
# require File.dirname(__FILE__) + "/../spec_helper"
# 
# describe 'create ParagraphJ' do
#   before do
#     @pj       = ParagraphJ.new(nil, text_string: "")
#     @pdf_path = File.dirname(__FILE__) + "/../output/paragraph_japanese.pdf"
#   end
#   
#   it 'should create ParagraphJ' do
#     @pj.must_be_kind_of ParagraphJ
#   end
#   
#   it 'should have japanese settings' do
#     @pj.text_direction.must_equal 'top_to_bottom'
#     @pj.text_advancement.must_equal 'right_to_left'
#     @pj.text_string.must_equal 'some japanese text'
#     
#   end
#   
#   
#   # it 'should save pdf' do
#   #   @pj.save_pdf(@pdf_path)
#   # end
# end