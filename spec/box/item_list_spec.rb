require File.dirname(__FILE__) + "/../spec_helper"

describe 'create ItemList' do
  before do
    items = [["one", "two", "three"], ["one-1","two-1","three-1"]]
    @il = ItemList.new(items: items, width: 600, item_height: 20)
    
  end
  
  it 'should create ItemList' do
    assert @il.class == ItemList
    assert @il.graphics.length == 2
  end
    
  it 'should create ItemRow' do
    assert @il.graphics.first.class == ItemRow
    assert @il.graphics.length == 2
  end
  
  it 'should create Item cells' do
    assert @il.graphics.first.graphics.first.class == Text
    assert @il.graphics.first.graphics.length == 3
    assert @il.graphics.first.graphics.first.width == 200
    assert @il.graphics.first.graphics.first.height == 20
    # @il.graphics.first.graphics.each do |cell|
    #   puts cell.class
    #   cell.puts_frame
    # end
  end
  
end