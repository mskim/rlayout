require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe 'create Essay from body.md' do
  before do
    # @project_path  = "#{ENV["HOME"]}/test_data/book/paperback"
    @project_path  = "#{ENV["HOME"]}/test_data/book/essay_with_book_md"
    @paperback = Paperback.new(@project_path)
  end

  it 'should create Book' do
    assert_equal RLayout::Paperback, @paperback.class 
  end
end
