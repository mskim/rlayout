require File.dirname(__FILE__) + "/spec_helper"
# 
describe 'create page' do
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
     # system("open #{@page_pdf_test}") if File.exists?(@page_pdf_test)
   end
end

describe 'create page with fixtures' do
  before do
    options = {}
    options[:header]     = true
    options[:footer]     = true 
    options[:header]     = true 
    options[:story_box]  = true
    @p = Page.new(self, options)    
  end

  it 'should have header' do
    @p.must_be_kind_of Page
    @p.header.must_be_kind_of Header
    @p.footer.must_be_kind_of Footer
    @p.side_bar.must_be_kind_of SideBar
    
  end
  
  it 'should save pdf' do
    @pdf_path = File.dirname(__FILE__) + "/output/page_fixture_test.pdf"
    @p.save_pdf(@pdf_path)
    File.exists?(@pdf_path).must_equal true
    # system("open #{@page_svg_test}") if File.exists?(@page_svg_test)
  end
  
end

describe 'create right_side page  ' do
  before do
    options = {}
    options[:header]     = true
    options[:footer]     = true 
    options[:header]     = true 
    options[:story_box]  = true
    @p = Page.new(self, options)    
  end

  it 'should have header' do
    @p.must_be_kind_of Page
    @p.header_object.must_be_kind_of Header
    @p.footer_object.must_be_kind_of Footer
    @p.side_bar_object.must_equal nil
    
  end
  
  it 'should save pdf' do
    @pdf_path = File.dirname(__FILE__) + "/output/page_fixture_test.pdf"
    @p.save_pdf(@pdf_path)
    File.exists?(@pdf_path).must_equal true
    # system("open #{@page_svg_test}") if File.exists?(@page_svg_test)
  end
  
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


