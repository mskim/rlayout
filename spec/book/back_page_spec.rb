require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe 'create BackPage' do
  before do
    @project_path  = "/Users/mskim/test_data/book_cover/back_page"
    @pdf_path = "/Users/mskim/test_data/book_cover/back_page/output.pdf"
    @back_page = BackPage.new(project_path: @project_path)
  end

  it 'should create BackPage' do
    assert_equal RLayout::BackPage, @back_page.class 
  end

  it 'should create BackPage' do
    assert File.exist?(@pdf_path) 
    system "open #{@pdf_path}"
  end
end
