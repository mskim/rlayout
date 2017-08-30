require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

# describe 'creating NewsImage ' do
#   before do
#     options= {
#       :caption_title=> "이를면 내일 목포항으로 출발",
#       :caption=> "약 2년 11개월 만에 모습을 들러낸 새월호가 26일 반잠수식 선박 위에서 선체속 물을 빼내고 있다. 배 안의 물과 기름을 제거하고 선체에 고정 작업을 마친 세월호는 이를먄 28일 목포신항으로 옮겨진다.",
#     }
#     @n_image              = NewsImage.new(options)
#     @image_box            = @n_image.image_box
#     @caption_column       = @n_image.caption_column
#   end
#
#   it "should create NewsImage class" do
#     assert_equal NewsImage, @n_image.class
#     assert_equal RLayout::Image, @image_box.class
#     assert_equal RLayout::CaptionColumn, @caption_column.class
#   end
#
# end


describe 'creaet NewsArticleMaker with Image' do
  before do
    @article_path   = "/Users/mskim/Development/rails5/style_guide/public/1/section/1/7x15_H_5단통_4/1"
    @article_path   = "/Users/mskim/Development/rails5/style_guide/public/1/issue/1/1/1"
    @article_path   = "/Users/mskim/Development/rails5/style_guide/public/1/issue/2017-05-30/1/2"
    @svg_path       = @article_path + "/output.svg"
    @maker          = NewsArticleMaker.new(article_path: @article_path)
    @news_box       = @maker.news_article_box
    @news_image     = @news_box.news_image
    @caption_column = @news_image.caption_column
    @line           = @caption_column.graphics.first
  end

  it 'should create NewsImage ' do
    assert_equal NewsImage, @news_image.class
    assert_equal Image, @news_image.image_box.class
    assert_equal NewsImage, @news_image.class
  end

  it 'should create image and caption ' do
    assert_equal NewsImage, @news_image.class
    assert_equal Image, @news_image.image_box.class
    assert_equal CaptionColumn, @news_image.caption_column.class
  end

  it 'should create NewsLineFragment ' do
    assert_equal NewsLineFragment, @line.class
  end

  # it 'lines shoule have tokens' do
  #   assert_equal TextToken, @line.graphics.first.class
  # end



end
