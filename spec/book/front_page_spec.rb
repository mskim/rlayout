require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe 'create FrontPage' do
  before do
    @document_path  = "#{ENV["HOME"]}/test_data/front_page"
    @pdf_path = "#{ENV["HOME"]}/test_data/front_page/output.pdf"
    @front_page = FrontPage.new(document_path: @document_path)
  end

  it 'should create FrontPage' do
    assert_equal RLayout::FrontPage, @front_page.class 
  end

  it 'should create FrontPage' do
    assert File.exist?(@pdf_path) 
    system "open #{@pdf_path}"
  end
end
