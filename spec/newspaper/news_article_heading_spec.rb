require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'creating HewsArticleHeading' do
  before do
    options= {
      title: "Sample Title",
      subtitle: "This is subtitle of the article",
      author: "Min Soo Kim"
    }
    @nh = NewsArticleHeading.new(options)
  end
  
  it "should create NewsArticleHeading class" do
    assert_equal NewsArticleHeading, @nh.class
  end

end
