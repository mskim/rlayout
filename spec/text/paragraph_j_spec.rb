# 
# require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"
# 
# describe 'create ParagraphJ' do
#   before do
#     @pj       = ParagraphJ.new(text_string: "")
#     @pdf_path = "/Users/Shared/rlayout/output/paragraph_japanese.pdf"
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


# describe 'create ParagraphJ' do
#   before do
#     @pj       = Paragraph.new(inset:50, width: 400, height: 600, text_direction: 'top_to_bottom', text_size:12, text_string:  "しかし、これは非常に複雑で、広範囲であるために一般的に使用するには無理が伴います。SGMLの規則によりながら、Webに使用するいくつかのマークアップのみを定義して使用したものがHTMLです。")
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
