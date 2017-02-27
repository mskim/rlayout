require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'overlapping lines' do
  before do
    @article_path   = "/Users/mskim/Development/rails5/articles/public/current_issue/1/1"
    @maker          = NewsArticleMaker.new(article_path: @article_path)
    @news_box       = @maker.news_article_box
    @heading        = @news_box.floats.first
    @image          = @news_box.floats[1]
    @first_column   = @news_box.graphics.first
    @second_column  = @news_box.graphics[1]
    @third_column   = @news_box.graphics[2]
    @fourth_column  = @news_box.graphics[3]
  end

  it 'should collect overlapping floats with column' do
    assert_equal @heading, @news_box.overlapping_floats_with_column(@first_column).first
    assert_equal @heading, @news_box.overlapping_floats_with_column(@second_column).first
    assert_equal @image, @news_box.overlapping_floats_with_column(@third_column).first
    assert_equal @image, @news_box.overlapping_floats_with_column(@fourth_column).first
  end
end

describe 'overlapping floats' do
  before do
    @article_path   = "/Users/mskim/Development/rails5/articles/public/current_issue/1/1"
    @maker          = NewsArticleMaker.new(article_path: @article_path)
    @news_box       = @maker.news_article_box
    @heading        = @news_box.floats.first
    @image          = @news_box.floats[1]
    @first_column   = @news_box.graphics.first
    @first_column_first_line    = @first_column.graphics.first
    @first_column_last_line     = @first_column.graphics.last
    @second_column              = @news_box.graphics[1]
    @second_column_first_line   = @second_column.graphics.first
    @second_column_last_line    = @second_column.graphics.last
    @third_column               = @news_box.graphics[2]
    @third_column_first_line    = @third_column.graphics.first
    @third_column_last_line     = @third_column.graphics.last
    @fourth_column              = @news_box.graphics[3]
    @fourth_column_first_line   = @fourth_column.graphics.first
    @fourth_column_last_line    = @fourth_column.graphics.last
  end

  it 'should adjust overlapping line text_area in first column' do
    assert_equal 0, @first_column_first_line.text_area[2]
    assert_equal 147.221428571428, @first_column_last_line.text_area[2]
  end

  it 'should adjust overlapping line text_area in second column' do
    assert_equal 0, @second_column_first_line.text_area[2]
    assert_equal 147.221428571428, @second_column_last_line.text_area[2]
  end

  it 'should adjust overlapping line text_area in third column' do
    assert_equal 0, @third_column_first_line.text_area[2]
    assert_equal 0, @third_column_last_line.text_area[2]
  end

  it 'should adjust overlapping line text_area in fourth column' do
    assert_equal 0, @fourth_column_first_line.text_area[2]
    assert_equal 0, @fourth_column_last_line.text_area[2]
  end
end

describe 'save NewsColumn as SVG'  do
  before do
    @para         = NewsParagraph.new(para_string: "This is a sample text. ")
    @news_article = NewsArticleBox.new(grid_frame: [0,0,2,3])
    @tc           = @news_article.graphics.first
    @para.layout_lines(@tc)
    @svg_path = "/Users/Shared/rlayout/output/text_column_test.svg"
  end

  it 'should get line_string for NewsColumn' do
    column_string = @tc.column_line_string
    assert_equal "This is a sample text.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", @tc.column_line_string
  end

  # it 'shlud save svg' do
  #   # puts  @tc.to_svg
  #   @tc.save_svg(@svg_path)
  #   assert File.exist?(@svg_path)
  #   # system("open #{@svg_path}")
  # end

end
