require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'create new book ' do
  before do
    # @project_path  = "#{ENV["HOME"]}/test_data/book/fresh_start"
    @project_path  = "#{ENV["HOME"]}/Development/tech_media/green_garden"
    @book = Book.new(@project_path)
  end

  it 'should create Book' do
    assert_equal RLayout::Book, @book.class 
  end
end


__END__
describe 'create buiㅣd book.md' do
before do
  @project_path  = "#{ENV["HOME"]}/test_data/book/paperback_with_book_md"
  # @project_path  = "/Users/mskim/Development/bookcheego/starters/paperback_starter"
  @paperback = Book.new(@project_path)
end

it 'should create Book' do
  assert_equal RLayout::Book, @paperback.class 
end
end

