require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"


describe 'create NewsPage' do
  before do
    @section_path   =  "/Users/mskim/test_data/2017-05-30/1"
    @page           = NewsPageAuto.new(page_path: @section_path, relayout:true)
  end

  it 'should create NewsPageAuto' do
    assert_equal NewsPageAuto, @page.class
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
