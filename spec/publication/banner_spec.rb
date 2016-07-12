require File.dirname(__FILE__) + "/../spec_helper"

describe 'create Banner' do
  before do
    @banner = Banner.new
    
  end
  
  it 'should create Banner' do
    assert @banner.class == Banner
  end
  
end

