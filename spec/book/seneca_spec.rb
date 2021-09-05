require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe 'create Seneca' do
  before do
    @project_path  = "/Users/mskim/test_data/book_cover/seneca"
    @pdf_path = "/Users/mskim/test_data/book_cover/seneca/seneca.pdf"
    @seneca = Seneca.new(project_path: @project_path)
  end

  it 'should create Seneca' do
    assert_equal RLayout::Seneca, @seneca.class 
  end

  it 'should create Seneca' do
    assert File.exist?(@pdf_path) 
    system "open #{@pdf_path}"
  end
end
