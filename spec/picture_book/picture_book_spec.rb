require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"
include RLayout

describe "create PictureBook" do
  before do
    @project_path = "/Users/mskim/test_data/picture_book"
    @book = PictureBook.new(project_path: @project_path)
  end

  it 'should create PictureBook' do
    assert_equal PictureBook, @book.class
  end

end