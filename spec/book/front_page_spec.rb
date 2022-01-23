require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe 'create FrontPage' do
  before do
    @project_path  = "/Users/mskim/test_data/book_cover/front_page"
    @pdf_path = "/Users/mskim/test_data/book_cover/front_page/output.pdf"
    @back_bing = FrontPage.new(project_path: @project_path)
  end

  # it 'should create BackWing' do
  #   assert_equal RLayout::FrontPage, @back_bing.class 
  # end

  it 'should create FrontPage' do
    assert File.exist?(@pdf_path) 
    system "open #{@pdf_path}"
  end
end
