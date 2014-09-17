require File.dirname(__FILE__) + "/../spec_helper"

describe 'TextColumn creation test' do
  before do
    @tb   = TextColumn.new(nil, :width=>400, :height=>800)
    @path = File.dirname(__FILE__) + "/../output/text_column_test.svg"
    # puts @para.inspect
    
  end
  
  it 'should create TextColumn object' do
    @tb.must_be_kind_of TextColumn
  end
  
  it 'should insert paragraphs' do
    @para_list = Paragraph.generate(5)
    @para_list.must_be_kind_of Array
    @para_list.first.must_be_kind_of Paragraph
    @para_list.each do |item|
      item.change_width_and_adjust_height(@tb.width)
      @tb.insert_item(item)
    end
    @tb.relayout!
    @tb.save_svg(@path)
    File.exists?(@path).must_equal true
  end
  
end
