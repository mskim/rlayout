require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe 'create BookMerger' do
  before do
    @project_path  = "#{ENV["HOME"]}/test_data/book/paperback"
    @book_md_path = @project_path +"/book.md"
    @book_merger = BookMerger.new(project_path: @project_path)
  end

  it 'should create BookMerger' do
    assert_equal RLayout::BookMerger, @book_merger.class 
  end

end

