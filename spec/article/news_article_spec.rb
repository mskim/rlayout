require File.dirname(__FILE__) + "/../spec_helper"
require File.dirname(__FILE__) + '/../../lib/rlayout/article/news_article'

describe 'create NewsArticle with Image' do
  before do
    @story_path = "/Users/mskim/news_article/my_journey.markdown"
    @m = NewsArticle.new(nil, :story_path=>@story_path, :heading_columns=>2)    
  end
  
  it 'should save' do    
    @pdf_path = File.dirname(__FILE__) + "/../output/news_article.pdf"
    @m.save_pdf(@pdf_path)
    File.exists?(@pdf_path).must_equal true
    system("open #{@pdf_path}")
  end
  
  # it 'should save yml' do    
  #   @yml_path = File.dirname(__FILE__) + "/../output/news_article.yml"
  #   @m.save_yml(@yml_path)
  #   File.exists?(@yml_path).must_equal true
  # end
end
