require File.dirname(__FILE__) + "/../spec_helper"

describe 'read markdow table' do
  before do
    story_path  = "/Users/mskim/Development/ruby/gems/rlayout/sample/story/sample_story.md"
    story_path  = "/Users/mskim/demo_book/001.chapter.md"
    @html       = "/Users/mskim/demo_book/001.chapter.html"
    @adoc       = "/Users/mskim/demo_book/001.chapter.html"
    @story      = Story.new(story_path)
    @para_data  = @story.markdown2para_data
    @asciidoctor= @story.to_html
  end
  # 
  # it 'shold create story' do
  #   assert @story.class == Story
  # end
  # 
  # it 'shold create story' do
  #   assert @para_data.class == Hash
  # end
  
  it 'should return :heading Hash' do
    assert @para_data[:heading].class == Hash
  end
  
  # it 'should return :paragraphs Array' do
  #   assert @para_data[:paragraphs].class == Array
  # end

  it 'should return :heading Hash' do
    puts @asciidoctor
    assert @asciidoctor.class == String
  end
  
  it 'should create html' do
    assert File.exist?(@adoc) == true
    assert File.exist?(@html) == true
    system "open #{@html}"
  end
end

__END__
describe 'reading story' do
  before do
    story_path = "/Users/mskim/magazine_article/sample.markdown"
    @story  = Story.markdown2para_data(story_path)
    puts @story
    @story[:paragraphs].each do |para|
      puts para[:markup]
    end
  end
    
  it 'should read markdown' do
    assert @story.is_a?(Hash)
  end
  it 'should have heading and paragraphs' do
    assert @story[:heading]
    assert @story[:paragraphs]
  end
end

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

