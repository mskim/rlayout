
require File.dirname(__FILE__) + "/../spec_helper"

describe ' label creation' do
  before do
    @l = RLayout::Label.new(:text_string=>"T: 010-7468-8222")
  end
  
  it 'should create Label' do
    assert @l.class == Label
  end
  
  it 'should have label_text' do
    assert @l.label_text == "T:"
  end
  
  it 'should have label_length' do
    assert @l.label_length == 2
  end
end