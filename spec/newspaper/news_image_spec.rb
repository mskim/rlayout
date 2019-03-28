require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'creaet NewsBoxMaker with Image' do
  before do
    @article_path   = "/Users/mskim/Development/style_guide/public/1/issue/2017-05-30/21/2"
    @maker          = NewsBoxMaker.new(article_path: @article_path)
    @news_box       = @maker.news_box
    puts "@news_box.class:#{@news_box.class}"

    @news_image     = @news_box.floats[1]
    # puts "@news_image.width:#{@news_image.width}"
  end

  it 'should create NewsImage ' do
    assert_equal NewsImage, @news_image.class
    assert_equal "일반", @news_image.image_kind
    assert_equal NewsImage, @news_box.floats[1].class
  end
end
