require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe 'test IsbnPage' do
  before do
    @section_path  = "#{ENV["HOME"]}/test_data/isbn_page"
    @pdf_path = @section_path + "/output.pdf"
    FileUtils.mkdir_p(@section_path) unless File.exist?(@section_path)
    @isbn_page = RLayout::IsbnPage.new(@section_path)
  end

  it 'should create IsbnPage' do
    assert_equal RLayout::IsbnPage, @isbn_page.class
  end

  it 'should save IsbnPage' do
    assert File.exist?(@pdf_path) 
    system "open #{@pdf_path}"
  end
end
