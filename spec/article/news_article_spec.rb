require File.dirname(__FILE__) + "/../spec_helper"
require File.dirname(__FILE__) + '/../../lib/rlayout/article/news_article'

describe 'create NewsArticle with Image' do
  before do
    @story_path = "/Users/mskim/news_article/my_journey.markdown"
    options={
      story_path: @story_path, 
      heading_columns: 2, 
      left_margin: 10, 
      right_margin: 10, 
      top_margin: 10, 
      bottom_margin: 10,
    }
    
    @m = NewsArticle.new(nil, options)    
  end
  
  it 'should save' do    
    @pdf_path = File.dirname(__FILE__) + "/../output/news_article.pdf"
    @m.save_pdf(@pdf_path)
    File.exists?(@pdf_path).must_equal true
    system("open #{@pdf_path}")
  end
end
