require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"
describe "create Chapter with page_floats" do
  before do
    @document_path = "#{ENV["HOME"]}/test_data/chapter"
    h = {}
    h[:width] = SIZES['A5'][0]
    h[:height] = SIZES['A5'][1]
    h[:left_margin] = 50
    h[:top_margin] = 50
    h[:right_margin] = 50
    h[:bottom_margin] = 50
    h[:document_path] = @document_path
    h[:starting_page_number] = 14
    h[:jpg] = false
    h[:body_line_count] = 40
    @chapter  = RLayout::Chapter.new(**h)
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
