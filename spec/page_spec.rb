require File.dirname(__FILE__) + "/spec_helper"
# 
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

describe 'generate svg' do
  before do
    # @doc  = Document.new
    # @con1 = Text.new(nil, text_size:50, x: 100, y:500, fill_color: "yellow", string: "Test is working")
    # @con2 = RoundRect.new(nil, x: 100, y:100, width: 200, height: 100, fill_color: "red", line_color: "black", line_width: 5)
    # @con3 = Container.new(nil, x: 200, y:200, width: 100, height: 100, fill_color: "green")
    # @con4 = Circle.new(nil, x: 300, y:300, width: 300, height: 300, fill_color: "gray")
    @page = Page.new(nil)
    Container.new(@page)
    Container.new(@page)
    Container.new(@page)
    Container.new(@page)
    @page_svg_test = File.dirname(__FILE__) + "/output/page_svg_test.svg"
    @page_json_test = File.dirname(__FILE__) + "/output/page_svg_test.json"
  end
  
  # it 'should save svg' do
  #    @page.save_svg(@page_svg_test)
  #    File.exists?(@page_svg_test).must_equal true
  #    # system("open #{@page_svg_test}") if File.exists?(@page_svg_test)
  #  end
   
  it 'should save JSON' do
    @page.save_json(@page_json_test)
    File.exists?(@page_json_test).must_equal true
    system("open #{@page_svg_test}") if File.exists?(@page_svg_test)
  end
end

