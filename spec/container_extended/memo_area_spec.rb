require File.dirname(__FILE__) + "/../spec_helper"

describe 'create memo_area' do
  before do
    @memo = MemoArea.new(nil)
  end
  
  it 'should create MemoArea' do
    assert @memo.class == MemoArea
  end
  
  it 'should create title' do
    assert @memo.graphics.first.class == Text
  end
  
  it 'should create line' do
    assert @memo.graphics[1].class == Line
  end
  
end
