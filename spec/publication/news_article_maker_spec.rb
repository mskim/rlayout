require File.dirname(__FILE__) + "/../spec_helper"

require 'minitest/autorun'
describe 'create NewsArticle sample' do
  before do
    @sample = RLayout::NewsArticleMaker.sample('/Users/mskim/news_article/sample', 5)
    @first_story_path = '/Users/mskim/news_article/sample/1.story.md'
  end

  it 'should create sample article' do
    File.exist?(@first_story_path).must_equal true
  end
end
