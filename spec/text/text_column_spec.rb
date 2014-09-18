require File.dirname(__FILE__) + "/../spec_helper"

describe 'TextColumn creation test' do
  before do
    @tb       = TextColumn.new(nil, :width=>300, :height=>800)
    @path     = File.dirname(__FILE__) + "/../output/text_column_test.svg"
    @pdf_path = File.dirname(__FILE__) + "/../output/text_column_test.pdf"
    # puts @para.inspect
  end
  
  it 'should create TextColumn object' do
    @tb.must_be_kind_of TextColumn
    @tb.line_grid_height.must_equal 30
    @tb.line_grid_offset.must_equal 0
    @tb.line_grid_count.must_equal 26
    @tb.line_grid_rects.must_be_kind_of Array
  end
  
  it 'should insert paragraphs' do
    @para_list = Paragraph.generate(5)
    @para_list.must_be_kind_of Array
    @para_list.first.must_be_kind_of Paragraph
    @para_list.each do |item|
      item.change_width_and_adjust_height(@tb.width)
      @tb.insert_item(item)
    end
    # @tb.relayout!

    # @tb.save_svg(@path)
    @tb.save_pdf(@pdf_path)
    File.exists?(@pdf_path).must_equal true
  end
  
end
