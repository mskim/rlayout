require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe 'create manual' do
  before do
    @project_path  = "/Users/mskim/test_data/book/manual"
    @manual = Book.new(@project_path)
  end

  it 'should create Seneca' do
    assert_equal RLayout::Book, @manual.class 
  end

  # it 'should create Seneca' do
  #   assert File.exist?(@pdf_path) 
  #   system "open #{@pdf_path}"
  # end
end
