require File.dirname(__FILE__) + "/../spec_helper"

describe 'newspaper body text' do
  before do
    @sr = RLayout::StyleService.shared_style_service
    @news_style = @sr.news_style
  end
  
  it 'should return current_style_body_height' do
    
  end
    
end


describe 'create StyleService' do
  before do
    @sr = RLayout::StyleService.shared_style_service
  end
  
  it 'should create StyleService' do
    assert @sr.class == RLayout::StyleService
  end
  
  it 'should have chapter_style' do
    assert @sr.chapter_style.class == Hash
    assert @sr.news_style.class == Hash
    assert @sr.magazine_style.class == Hash
  end
  
  it 'should have chapter_style["body"]' do
    assert @sr.chapter_style['body'][:font] == 'Times'
    assert @sr.chapter_style['body'][:text_size] == 10
  end
  
end