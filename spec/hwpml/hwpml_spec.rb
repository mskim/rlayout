require File.dirname(__FILE__) + "/../spec_helper"

describe 'create hwpml' do
  before do
    @path = "/Users/mskim/Development/hwp/section_test.hml"
    @path = "/Users/mskim/Development/hwp/section_test1.hml"
    @path = "/Users/mskim/Development/hwp/ms.hml"
    @hwp  = Hwpml.new(path: @path)
  end
  
  it 'should crete Hwpml' do
    assert @hwp.class == Hwpml
    puts @hwp.block_list
  end
  
  # it 'should crete char_styles' do
  #   assert @hwp.char_styles.first.class == Hash
  # end
  # 
  # it 'should crete para_styles' do
  #   assert @hwp.para_styles.first.class == Hash
  # end
  # 
  # it 'should crete styles' do
  #   assert @hwp.styles.first.class == Hash
  # end
  # 
end

