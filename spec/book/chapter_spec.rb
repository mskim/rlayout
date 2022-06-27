require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"
describe "create Chapter with page_floats" do
  before do
    @document_path = "#{ENV["HOME"]}/test_data/chapter"
    @chapter  = RLayout::Chapter.new(document_path: @document_path, starting_page_number: 14, jpg: false)
    @document = @chapter.document
  end

  it "should create Chapter" do
    assert_equal RLayout::Chapter, @chapter.class 
  end

  it 'should start at ' do
    assert_equal RLayout::RDocument, @document.class 
    assert_equal 14, @document.first_page.page_number
  end
end
