require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'testing GroupImage with grouped_caption' do
  before do
    # @container = Container.new(:width=>600, :height=>800, :layout_space=>20, :layout_direction=>"horizontal") do
    # @image_items = %w[1.jpg 2.jpg]
    @pdf_path = "/Users/mskim/test_data/grouped_caption/output.pdf"
    @text_string_array = %w[강경자 조경자 박경자 정경자 민경자]
    @g = GroupedCaption.new(column:3, row:2, :width=>200, :height=>40, text_string_array: @text_string_array, output_path: @pdf_path)
  end

  it 'should save pdf GroupImage' do
    @g.save_pdf(@pdf_path)
    assert File.exist?(@pdf_path) == true
    system "open #{@pdf_path}"
  end
end
