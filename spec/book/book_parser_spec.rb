require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe 'create BookPart' do
  before do
    @project_path  = "#{ENV["HOME"]}/test_data/book_parser"
    @book_md_path = @project_path + "/book.md"
    @pdf_path = @project_path + "/book.md"
    unless File.exist?(@project_path)
      FileUtils.mkdir_p(@project_path) 
      BookParser.save_sample(@book_md_path) 
    end
    @book_file = BookParser.new(@book_md_path)
  end

  it 'should create BookPart' do
    assert_equal RLayout::BookParser, @book_file.class 
  end

  # it 'should create pdf' do
  #   assert File.exist?(@pdf_path) 
  #   system "open #{@pdf_path}"
  # end
end


describe 'create BookPart' do
  before do
    @project_path  = "#{ENV["HOME"]}/test_data/book_parser_with_part"
    @book_md_path = @project_path + "/book.md"
    unless File.exist?(@project_path)
      FileUtils.mkdir_p(@project_path) 
      BookParser.save_sample_with_part(@book_md_path) unless File.exist?(@sample_path)
    end
  @book_file = BookParser.new(@book_md_path)
  end

  it 'should create BookPart' do
    assert_equal RLayout::BookParser, @book_file.class 
  end

end