require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'overflowing paragragraph' do
  before do
    @article_path   = "/Users/mskim/Development/rails5/articles/public/current_issue/1/1"
    @article_path   = "/Users/mskim/Development/rails5/page_template/public/current_issue/2/3"
    @article_path   = "/Users/mskim/Development/rails5/style_guide/public/1/6/3x4/0"
    @article_path   = "/Users/mskim/Development/rails5/style_guide/public/1/issue/1/22/2"
    @article_path   = "/Users/mskim/Development/rails5/style_guide/public/1/issue/2017-05-30/23/2"
    @svg_path       = @article_path + "/output.svg"
    @maker          = NewsBoxMaker.new(article_path: @article_path)
    @news_box       = @maker.news_box
    @heading        = @news_box.floats.first
    @image          = @news_box.floats[1]
    @first_column   = @news_box.graphics.first
    @second_column  = @news_box.graphics[1]
    @third_column   = @news_box.graphics[2]
    @overflow_column = @news_box.overflow_column
    @box_width      = (@first_column.width)*3 + (@news_box.gutter)*2
    @first_text_line = @news_box.first_text_line
  end

  it 'should create NewsHeadingForArticle' do
    assert_equal NewsArticleBox, @news_box.class
  end

  # it 'should have lines' do
  #   assert_equal NewsLineFragment, @first_text_line.class
  # end

end

__END__
describe 'create news_paragrah' do
  before do
    para            = {markup: 'p', para_string: "this is a string"}
    @news_paragrah  = NewsParagraph.new(para)
  end

  it 'shoule create NewsParagraph' do
    assert_equal NewsParagraph, @news_paragrah.class
  end
end


describe 'create news_paragrah' do
  before do
    para            = {markup: 'p', para_string: "this is a string"}
    @news_paragrah  = NewsParagraph.new(para)
  end

  it 'shoule create NewsParagraph' do
    assert_equal NewsParagraph, @news_paragrah.class
  end
end

describe 'create news_paragrah with strong emphasis' do
  before do
    para            = {markup: 'p', para_string: "**this** is a string"}
    @news_paragrah  = NewsParagraph.new(para)
    @first_token    = @news_paragrah.tokens.first
  end

  it 'shoule create token with strong style' do
    assert_equal TextToken, @first_token.class
  end
end
