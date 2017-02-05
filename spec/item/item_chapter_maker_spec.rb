require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'create ItemChapterMaker' do
  before do
    @project_path= "/Users/mskim/demo_item_chapter"
    @maker      = ItemChapterMaker.new(project_path: @project_path)
  end
  
  it 'should create ItemChapterMaker' do
    assert @maker.class == ItemChapterMaker
  end
  
  it 'should create items array' do
    assert @maker.items.class == Array
  end
    
end
