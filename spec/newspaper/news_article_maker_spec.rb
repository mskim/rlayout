require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"


describe 'creaet document with NewsBoxMaker' do
  before do
    @article_path   = "/Users/mskim/Development/rails5/style_guide/public/1/issue/2018-04-01/23/1"
    @article_path   = "/Users/mskim/Development/rails5/style_guide/public/1/issue/2018-04-01/23/2"
    # @article_path   = "/Users/mskim/Development/rails5/style_guide/public/1/issue/2017-05-30/22/3"
    puts "@article_path:#{@article_path}"
    @maker          = NewsBoxMaker.new(article_path: @article_path, fill_up_enpty_lines: true)
    @news_box       = @maker.news_box
    @heading        = @news_box.heading
    @title          = @heading.title_object
    @first_column   = @news_box.graphics.first
    @eews_article_box_width = @first_column.width*4 + 10*6
    @first_column_first_line = @first_column.graphics.first
    @tokens         = @first_column_first_line.graphics
    # @second_column  = @news_box.graphics[1]
    # @second_column_first_line = @second_column.graphics.first
    # @third_column   = @news_box.graphics[2]
  end

  it 'should create NewsArticleBox' do
    assert_equal NewsArticleBox, @news_box.class
  end

  # it 'should create NewsBoxMaker' do
  #   assert_equal NewsHeadingForOpinion, @heading.class
  #   # assert_equal 10, @news_box.gutter
  # end
  #
  # it 'should create columns with shorter height by 2' do
  #   assert_equal @first_column.height + (@first_column_first_line.height)*2, @news_box.height
  # end

    #
  # it 'should create NewsArtcicleHeading' do
  #   assert_equal NewsHeadingForArticle, @heading.class
  #   assert_equal Text, @title.class
  # end
  #
  # it 'should create NewsArticleBox subtitle float' do
  #   assert_equal 3, @news_box.floats.length
  #   assert_equal Text, @news_box.floats[1].class
  # end



#   it 'shold create NewsColumn' do
#     assert_equal NewsColumn, @first_column.class
#     assert_equal 10, @news_box.gutter
#     assert_equal @first_column.width, @second_column.width
#     assert_equal (@second_column.x - @first_column.width), 15
#     assert_equal @first_column.graphics.length, 30
#   end
#
#   it 'should create lines' do
#     assert_equal @first_column_first_line.width, @second_column_first_line.width
#     assert_equal @first_column_first_line.width, @first_column.width
#     assert_equal @first_column.graphics.length, @third_column.graphics.length
#     assert_equal @first_column_first_line.height, @first_column.height/30
#   end
#
#   it 'should layout tokens' do
#     assert_equal @first_column_first_line.graphics.length, 0
#     assert  @second_column_first_line.graphics.length, 0
#   end
#
#   it 'should save svg' do
#     assert_equal true, File.exist?(@svg_path)
#     # system "open #{@svg_path}"
#   end
#
#
end
