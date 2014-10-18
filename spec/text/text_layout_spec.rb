# 
# require File.dirname(__FILE__) + "/../spec_helper"
# 
# describe 'create TextLayout' do
#   before do
#     
#     @rtf       = TextLayout.new("att_string", [0,0,100,100], text_string: "some japanese text")
#     @pdf_path = File.dirname(__FILE__) + "/../output/rt_frame.pdf"
#     
#   end
#   
#   it 'should create TextLayout' do
#     @rtf.must_be_kind_of TextLayout
#   end
#   
#   it 'should have default settings' do
#     @rtf.line_direction.must_equal 'top_to_bottom'
#     @rtf.lines.must_be_kind_of Array
#     @rtf.runs.must_be_kind_of Array
#     
#   end
#   
#   # it 'should save pdf' do
#   #   @rtf.save_pdf(@pdf_path)
#   # end
# end