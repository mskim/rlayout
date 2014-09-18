require File.dirname(__FILE__) + "/spec_helper"
# 
describe 'generate svg' do
  before do
    @p = Page.new(nil)
    Container.new(@p, :fill_color=>'green')
    Container.new(@p)
    Container.new(@p)
    Container.new(@p)
    @page_pdf_test = File.dirname(__FILE__) + "/output/page_pdf_test.pdf"
  end
  
  it 'should save svg' do
     @p.save_pdf(@page_pdf_test)
     File.exists?(@page_pdf_test).must_equal true
     system("open #{@page_pdf_test}") if File.exists?(@page_pdf_test)
   end
   
   
   
   
   
   
   
   
   
   
   
   
  # it 'should save JSON' do
  # @page_json_test = File.dirname(__FILE__) + "/output/page_svg_test.json"
  
  #   @p.save_json(@page_json_test)
  #   File.exists?(@page_json_test).must_equal true
  #   # system("open #{@page_svg_test}") if File.exists?(@page_svg_test)
  # end
end

# describe 'Article Page with pgscritpt' do
#   before do
#     @p = Page.new(nil) do
#       article_layout
#     end
#     @page_svg_test = File.dirname(__FILE__) + "/output/page_svg_test2.svg"
#     
#   end
#   
#   it 'should create heading' do
#     @p.heading.must_be_kind_of Heading
#   end
#   
#   it 'should create body' do
#     @p.body.must_be_kind_of Body
#   end
#   
#   it 'should save svg' do
#     @p.save_svg(@page_svg_test)
#     File.exists?(@page_svg_test).must_equal true
#     # system("open #{@page_svg_test}") if File.exists?(@page_svg_test)
#   end
#   
# end
# 
# 
# describe "page" do
#   before do
#     @page = Page.new(nil)
#   end
#   
#   it 'page should create page ' do
#     @page.must_be_kind_of Page
#   end
#   
#   it 'page should have default values' do
#     @page.width.must_equal 600
#     @page.height.must_equal 800
#     @page.margin.must_equal 50
#     @page.graphics.must_equal []
#   end
# end
# 
# describe "page from document" do
#   before do
#     @doc  = Document.new
#     @page = Page.new(@doc)
#   end
#   
#   it 'page should create page ' do
#     @page.must_be_kind_of Page
#   end
#   
#   it 'page should have default values' do
#     @page.document.must_be_kind_of Document
#     @page.width.must_equal 600
#     @page.height.must_equal 800
#     @page.margin.must_equal 50
#     @page.graphics.must_equal []
#   end
# end


