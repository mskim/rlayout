require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'NewsToc' do
  before do
    @article_path   =  "#{ENV["HOME"]}/test_data/news_toc"
    @toc            = NewsToc.new(article_path: @article_path)
    @pdf_path       = @article_path + "/story.pdf"
  end

  it 'should create NewsToc' do
    assert RLayout::NewsToc,  @article_box.class
  end
  it 'should save pdf' do
    assert File.exist?(@pdf_path)
    system("open #{@pdf_path}")
end