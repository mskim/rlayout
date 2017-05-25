require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"


describe 'creaet NewsArticleMaker with Image' do
  before do
    @article_path   = "/Users/mskim/Development/rails5/style_guide/public/1/section/1/7x15_H_5단통_4/1"
    @svg_path       = @article_path + "/output.svg"
    @page           = NewspaperSectionPage.open(section_path: @article_path)
  end

  it 'should create NewsSectionPage' do
    assert_equal NewspaperSectionPage, @page.class
  end

  it 'should should have story_count of 4' do
    assert_equal 4, @page.number_of_stories
  end

end
