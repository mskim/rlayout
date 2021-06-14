require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'create NewsBoxMaker with Image' do
  before do
    @article_path   = "/Users/mskim/Development/pillar_layout/public/1/issue/2021-01-29/1/1/1"
    @maker          = NewsBoxMaker.new(article_path: @article_path)
    @news_box       = @maker.news_box
    @floats         = @news_box.floats
    @news_image     = @floats[1]
  end

  it 'should create NewsImage ' do
    assert_equal NewsImage, @news_image.class
    # assert_equal "인물_좌", @news_image.image_kind
    assert_equal 3, @news_box.floats.length
  end
end
