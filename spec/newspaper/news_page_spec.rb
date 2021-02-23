require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"


describe 'create NewsPage' do
  before do
    @page_path   =  "/Users/mskim/test_data/2021-01-29/2"
    # @page        = NewsPage.new(page_path: @page_path, relayout: true, time_stamp: true)
    @page        = NewsPage.new(page_path: @page_path, relayout: false)
  end

  it 'should create NewsPage' do
    assert_equal NewsPage, @page.class
  end

end

__END__
describe 'create NewsBoxMaker with Image' do
  before do
    @article_path   = "/Users/mskim/Development/rails5/style_guide/public/1/section/1/7x15_H_5단통_4/1"
    @section_path   = "/Users/mskim/Development/rails5/style_guide/public/1/issue/2017-05-30/22"
    @svg_path       = @article_path + "/output.svg"
    @page           = NewsPage.open(section_path: @section_path)
    @merger_page    = @page.merge_layout_pdf
    @first_article  = @merger_page.graphics.last
    @third_article  = @merger_page.graphics[2]
  end

  it 'should create NewsSectionPage' do
    assert_equal NewsPage, @page.class
  end

  it 'should should have story_count of 3' do
    assert_equal 3, @page.number_of_stories
  end

  it 'should hace ad_type of 5단통' do
    assert_equal  "5단통", @page.ad_type
  end

end
