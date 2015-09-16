require File.dirname(__FILE__) + "/../spec_helper"

describe 'create dorok' do
  before do
    @path = File.expand_path("~") + "/dorok"
    @dorok = Dorok.new(@path)
  end
  
  it 'should creat Dorok' do
    assert @dorok.class == RLayout::Dorok
  end
  
end

describe 'create dorok page' do
  before do
    @path = File.expand_path("~") + "/dorok/1"
    @dorok = DorokPage.new(@path)
  end
  
  it 'should creat DorokPage' do
    assert @dorok.class == RLayout::DorokPage
  end
  
  it 'should copy templaet' do
    @layout = @path + "/1-1.rb"
    @images   = @path + "/images"
    assert File.exist?(@layout) == true
    assert File.directory?(@images) == true
  end
  
end