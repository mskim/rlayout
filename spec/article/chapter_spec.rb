require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

# require File.dirname(__FILE__) + "/../../lib/rlayout/article/chapter_maker.rb"

describe 'Chapter' do
  before do
    story         = "/Users/mskim/magazine_article/sample.markdown"
    story_path    = "/Users/mskim/demo/demo_book/sample_book/01_chapter/story.md"
    project_path  = "/Users/mskim/demo/demo_book/sample_book/01_chapter"
    @doc          = Chapter.new(project_path: project_path)
  end

  it 'should create Chapter' do
    assert @doc.class == Chapter
  end

end

__END__
describe 'create document with Chapter' do
  before do
    template ="/Users/Shared/SoftwareLab/article_template/chapter.rb"
    story="/Users/mskim/magazine/how-to-creaete-soochup.markdown"
    @doc = Chapter.new(template: template, story_path: story)
  end

  it 'should create Chapter' do
    assert @doc.class == Chapter
  end

  # it 'should have value' do
  #   assert @doc.template_path == "/Users/Shared/SoftwareLab/article_template/chapter.rb"
  # end
  #
  # it 'should have value' do
  #   assert @doc.story_path == "Some/Story/path"
  # end

end

describe 'Chapter sample' do
  before do
    template ="/Users/Shared/SoftwareLab/article_template/chapter.rb"

    @path = "/Users/mskim/book/pastor/001.chapter.markdown"
    @chapter = Chapter.new(template: template, story_path: @path)
  end

  it 'shold create RLayout::Chapter' do
    assert @chapter.class == Chapter
  end

  # it 'should save pdf' do
  #   @pdf_path = "/Users/mskim/book/pastor/001.chapter.pdf"
  #   @chapter.save_pdf(@pdf_path)
  #   File.exist?(@pdf_path).should == true
  # end

end
