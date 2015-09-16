require File.dirname(__FILE__) + "/../spec_helper"

describe 'ChapterMaker layout image' do
  before do
    story   = "/Users/mskim/magazine_article/sample.markdown"
    story   = "/Users/mskim/book/pastor/sample.markdown"
    @story  = Story.markdown2para_data(story_path)
    @doc    = ChapterMaker.new(template: template, story_path: story)
  end
  
end

__END__
describe 'creaet document with ChapterMaker' do
  before do
    template ="/Users/Shared/SoftwareLab/article_template/chapter.rb"
    story="/Users/mskim/magazine/how-to-creaete-soochup.markdown"    
    @doc = ChapterMaker.new(template: template, story_path: story)
  end
  
  it 'should create ChapterMaker' do
    assert @doc.class == ChapterMaker
  end
    
  # it 'should have value' do
  #   assert @doc.template_path == "/Users/Shared/SoftwareLab/article_template/chapter.rb"
  # end
  # 
  # it 'should have value' do
  #   assert @doc.story_path == "Some/Story/path"
  # end
  
end

describe 'ChapterMaker sample' do
  before do
    template ="/Users/Shared/SoftwareLab/article_template/chapter.rb"
    
    @path = "/Users/mskim/book/pastor/001.chapter.markdown"
    @chapter = ChapterMaker.new(template: template, story_path: @path)
  end
  
  it 'shold create RLayout::Chapter' do
    assert @chapter.class == ChapterMaker
  end
  
  # it 'should save pdf' do
  #   @pdf_path = "/Users/mskim/book/pastor/001.chapter.pdf"
  #   @chapter.save_pdf(@pdf_path)
  #   File.exist?(@pdf_path).should == true
  # end
  
end