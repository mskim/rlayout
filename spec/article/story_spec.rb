
require File.dirname(__FILE__) + "/../spec_helper"
# require File.dirname(__FILE__) + "/../../article"


describe 'create Story' do
  before do
    @s = Story.new
    @path = @story_path = "/Users/mskim//news_article/2012-12-05-automation-catalog-publication.markdown"
    
  end
    
  it 'should create Story' do
    @s.must_be_kind_of Story
  end
  
  it 'generate sample' do    
    Story.sample.must_be_kind_of Story
  end
  
  it 'generate magazine article' do
    m = Story.magazine_article_sample
    m.must_be_kind_of Story
    m.heading[:title].must_be_kind_of String
    m.paragraphs.must_be_kind_of Array
  end
  
  it 'generate news article' do
    Story.news_article_sample.must_be_kind_of Story
  end
  
  it 'generate magazine' do
    Story.book_chapter.must_be_kind_of Story
  end
end

describe 'read meta_markdown' do
  before do
    @path = @story_path = "/Users/mskim//news_article/2012-12-05-automation-catalog-publication.markdown"
  end
  
  it 'story from_meta_markdown file' do
    m= Story.from_meta_markdown(@path)
    m.must_be_kind_of Story
    m.heading[:title].must_be_kind_of String
    m.paragraphs.must_be_kind_of Array
    m.heading[:author].must_equal "Min Soo Kim"
    m.paragraphs.each do |para|
      para[:string] if para[:markup] == "img"
    end
  end

end