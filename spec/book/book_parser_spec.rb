require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe 'create BookPart' do
  before do
    @project_path  = "/Users/mskim/test_data/book_parser"
    @sample_path = @project_path + "/book.md"
    FileUtils.mkdir_p(@project_path) unless File.exist?(@project_path)
    BookParser.save_sample(@sample_path) unless File.exist?(@sample_path)
    @book_file = BookParser.new(@project_path)
  end

  it 'should create BookPart' do
    assert_equal RLayout::BookParser, @book_file.class 
  end

  # it 'should create Seneca' do
  #   assert File.exist?(@pdf_path) 
  #   system "open #{@pdf_path}"
  # end
end


describe 'create BookPart' do
  before do
    @project_path  = "/Users/mskim/test_data/book_parser_with_part"
    @sample_path = @project_path + "/book.md"
    FileUtils.mkdir_p(@project_path) unless File.exist?(@project_path)
    BookParser.save_sample_with_part(@sample_path) unless File.exist?(@sample_path)
    @book_file = BookParser.new(@project_path)
  end

  it 'should create BookPart' do
    assert_equal RLayout::BookParser, @book_file.class 
  end

end