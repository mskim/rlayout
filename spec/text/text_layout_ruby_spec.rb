require File.dirname(__FILE__) + "/../spec_helper"

describe 'create TextLayoutRuby' do
  before do
    @t  = Text.new(nil)
    @tl = TextLayoutRuby.new(@t, :para_string=> "This is a para string.")
  end
  
  it 'should create TextLayoutRuby' do
    assert @tl.class ==  TextLayoutRuby
  end
  
  it 'should have ower_graphic' do
    assert @tl.owner_graphic == @t
  end
  
end