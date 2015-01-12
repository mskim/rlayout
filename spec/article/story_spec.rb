require File.dirname(__FILE__) + "/../spec_helper"
# require File.dirname(__FILE__) + "/../../article"
describe 'load stoy' do
  before do
    @body_markdown = "#### One is a first part of body. And some more text and some more of the text. This is the body text for the story. And some more lines of text is here.\n\n##### Here is four text and some more of the text.\n\nThis is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here.\n\n#### And some more text and some more of the text.\n\nThis is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here.\n\n#### And some more text and some more of the text.\n\nThis is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here.\n\n#### And some more text and some more\r\nof the text.\n\nThis is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here.\n\nThis is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here."
    @para_list = Story.parse_markdown(@body_markdown) 
  end
  it 'should parse markdown' do
    @para_list.must_be_kind_of Array
  end
  
  it 'should have h4 markup' do
    @para_list[0][:markup].must_equal "h4"
    @para_list[1][:markup].must_equal "h5"
    @para_list[2][:markup].must_equal "p"
  end
  
  it 'should have demotion level 5' do
    @para_list = Story.parse_markdown(@body_markdown, :demotion_level=>2) 
    @para_list[0][:markup].must_equal "h6"
    @para_list[1][:markup].must_equal "h6"
    @para_list[2][:markup].must_equal "p"
  end
end

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
