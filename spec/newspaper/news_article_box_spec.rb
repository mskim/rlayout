require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'overlapping floats' do
  before do
    @article_path   = "/Users/mskim/Development/rails5/articles/public/current_issue/1/1"
    @svg_path       = @article_path + "/output.svg"
    @maker          = NewsArticleMaker.new(article_path: @article_path)
    @news_box       = @maker.news_article_box
    @heading        = @news_box.floats.first
    @image          = @news_box.floats[1]
    @first_column   = @news_box.graphics.first
    @second_column  = @news_box.graphics[1]
    @third_column   = @news_box.graphics[2]
    @fourth_column   = @news_box.graphics[3]
    @box_width = (@third_column.width + @news_box.gutter)*4
  end

  it 'shold create image_box with multiples of column width' do
    assert_equal @box_width, @news_box.width
  end

  it 'should collect overlapping floats with column' do
    assert_equal @heading, @news_box.overlapping_floats_with_column(@first_column).first
    assert_equal @heading, @news_box.overlapping_floats_with_column(@second_column).first
    assert_equal @image, @news_box.overlapping_floats_with_column(@third_column).first
    assert_equal @image, @news_box.overlapping_floats_with_column(@fourth_column).first
  end
end


describe 'create NewsArticleBox' do
  before do
    @nab  = NewsArticleBox.new()
  end

  it 'shold create NewsArticleBox' do
    assert @nab.class == NewsArticleBox
  end

  it 'shold create TextColumn' do
    assert_equal 2, @nab.graphics.length
    assert_equal NewsColumn, @nab.graphics[0].class
  end

end
