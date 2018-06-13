require 'minitest/autorun'
require 'pry'
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '../..', 'lib')
require 'rlayout/style/style_service'
require 'rlayout/text/font'
include RLayout

describe 'string with of a style' do
  before do
    @sr = RLayout::StyleService.shared_style_service
    @news_style = @sr.news_style
  end
  it 'should calculate the width of a string' do
    width = @sr.width_of_string('body', "this is a string")
    width.must_be_close_to 55.8349609375
  end

end

describe 'newspaper body text' do
  before do
    @sr = RLayout::StyleService.shared_style_service
    @news_style = @sr.news_style
  end

  it 'should return current_style_body_height' do
    @news_style['p'][:font_size].must_equal 10
  end
end


describe 'create StyleService' do
  before do
    @sr = RLayout::StyleService.shared_style_service
  end

  it 'should create StyleService' do
    @sr.class.must_equal RLayout::StyleService
  end

  it 'should have chapter_style' do
    @sr.chapter_style.class.must_equal Hash
    @sr.news_style.class.must_equal Hash
    @sr.magazine_style.class.must_equal Hash
  end

  it 'should have chapter_style["body"]' do
    @sr.chapter_style['body'][:font].must_equal 'smSSMyungjoP-W30'
    @sr.chapter_style['body'][:font_size].must_equal 10
  end

end
