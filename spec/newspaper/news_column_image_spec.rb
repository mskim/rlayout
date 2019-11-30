require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'create NewsBoxMaker with Image' do
  before do
    @article_path   = "/Users/mskim/Development/rails5/style_guide/public/1/section/1/7x15_H_5단통_4/1"
    @article_path   = "/Users/mskim/Development/rails5/style_guide/public/1/issue/1/1/1"
    @article_path   = "/Users/mskim/Development/rails5/style_guide/public/1/issue/2017-05-30/1/2"
    @article_path   = "/Users/mskim/Development/rails5/style_guide/public/1/issue/2017-05-30/22/2"
    @maker          = NewsBoxMaker.new(article_path: @article_path)
    @news_box       = @maker.news_box
    @news_image     = @news_box.news_image
    @caption_column = @news_image.caption_column
  end

  it 'should create NewsImage ' do
    assert_equal NewsColumnImage, @news_image.class
    assert_equal Image, @news_image.image_box.class
    assert_equal NewsImage, @news_image.class
  end


end
