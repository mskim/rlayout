require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'creaet NewsBoxMaker with Image' do
  before do

    @article_path   = "/Users/mskim/Development/style_guide/public/1/issue/2019-03-03/1/2"
    @maker          = NewsBoxMaker.new(article_path: @article_path)
    @news_box       = @maker.news_box
    @news_image     = @news_box.floats[2]
    puts "@news_image.width:#{@news_image.width}"
  end

  it 'should create NewsImage ' do
    assert_equal NewsImage, @news_image.class
    assert_equal "인물_좌", @news_image.image_kind
    assert_equal TitleText, @news_box.floats[1].class
  end
end
