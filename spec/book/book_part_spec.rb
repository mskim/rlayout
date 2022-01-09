require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe 'create BookPart' do
  before do
    @project_path  = "/Users/mskim/test_data/book_part/part_1"
    @build_path  = "/Users/mskim/test_data/book_part/build/part_1"
    @part = BookPart.new(@project_path)
  end

  it 'should create BookPart' do
    assert_equal RLayout::BookPart, @part.class 
    assert File.exist?(@build_path)
  end

  # it 'should create Seneca' do
  #   assert File.exist?(@pdf_path) 
  #   system "open #{@pdf_path}"
  # end
end
