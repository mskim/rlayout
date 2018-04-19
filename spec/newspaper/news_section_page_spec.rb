require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"


describe 'creaet NewsSectionPage with divider_lines' do
  before do
    @section_path   = "/Users/mskim/Development/rails5/style_guide/public/1/issue/2017-05-30/22"
    @svg_path       = @section_path + "/output.svg"
    @page           = NewspaperSectionPage.open(section_path: @section_path)
    @merger_page    = @page.merge_layout_pdf
    @first_article  = @merger_page.graphics.last
    @third_article  = @merger_page.graphics[2]
  end

  it 'should create NewsSectionPage' do
    assert_equal NewspaperSectionPage, @page.class
  end

  it 'should should have story_count of 3' do
    assert_equal 3, @page.number_of_stories
  end

  it 'should have divider lines' do
    assert_equal  2, @page.divider_lines.length
  end

end

describe 'creaet NewsBoxMaker with Image' do
  before do
    @article_path   = "/Users/mskim/Development/rails5/style_guide/public/1/section/1/7x15_H_5단통_4/1"
    @section_path   = "/Users/mskim/Development/rails5/style_guide/public/1/issue/2017-05-30/22"
    @svg_path       = @article_path + "/output.svg"
    @page           = NewspaperSectionPage.open(section_path: @section_path)
    @merger_page    = @page.merge_layout_pdf
    @first_article  = @merger_page.graphics.last
    @third_article  = @merger_page.graphics[2]
  end

  it 'should create NewsSectionPage' do
    assert_equal NewspaperSectionPage, @page.class
  end

  it 'should should have story_count of 3' do
    assert_equal 3, @page.number_of_stories
  end

  it 'should hace ad_type of 5단통' do
    assert_equal  "5단통", @page.ad_type
  end

end
