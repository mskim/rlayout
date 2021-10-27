require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe 'create PoemBook' do
  before do
    @project_path  = "/Users/mskim/test_data/book/poem_book"
    @build_path  = "/Users/mskim/test_data/book/poem_book/build"
    @biild_book_cover_path = @build_path + "/book_cover"
    @biild_front_matter_path = @build_path + "/front_matter"
    @poem_book = PoemBook.new(@project_path)
  end

  it 'should create Essay' do
    assert_equal RLayout::PoemBook, @    @poem_book = PoemBook.new(@project_path)
    .class 
    assert File.exist?(@biild_book_cover_path)
    assert File.exist?(@biild_front_matter_path)
  end

  # it 'should create Seneca' do
  #   assert File.exist?(@pdf_path) 
  #   system "open #{@pdf_path}"
  # end
end
