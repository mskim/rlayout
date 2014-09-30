require File.dirname(__FILE__) + "/../spec_helper"

describe 'should create StoryBox' do
  before do
    @story_path = "/Users/mskim/news_article/2012-12-18-making-rlayout-for-variable-publishing.markdown"
    @rlib_path = "/Users/mskim/news_article/2012-12-18-making-rlayout-for-variable-publishing.rlib"
    @pdf_path = "/Users/mskim/news_article/2012-12-18-making-rlayout-for-variable-publishing.pdf"
    @svg_path = "/Users/mskim/news_article/2012-12-18-making-rlayout-for-variable-publishing.svg"
    @sb = StoryBox.new(nil, :width=>500, :height=>800, :story_path=>@story_path)

  end
  
  it 'should create StoryBox' do
    @sb.must_be_kind_of StoryBox
  end
  
  # it 'should save rlib' do
  #   @sb.save_rlib(@rlib_path)
  #   File.exists?(@rlib_path).must_equal true
  # end
  it 'should save pdf' do
    @sb.save_pdf(@pdf_path)
    File.exists?(@pdf_path).must_equal true
  end
  
  # it 'should save svg' do
  #   @sb.save_svg(@svg_path)
  #   File.exists?(@svg_path).must_equal true
  # end
  
end