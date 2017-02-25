require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'save NewsColumn as SVG'  do
  before do
    @para         = NewsParagraph.new(para_string: "This is a sample text. "*10)
    @news_article = NewsArticleBox.new(grid_frame: [0,0,2,3])
    @tc           = @news_article.graphics.first
    # @para.layout_lines(@tc)
    @svg_path = "/Users/Shared/rlayout/output/text_column_test.svg"
  end

  it 'should get line_string for NewsColumn' do
    column_string = @tc.column_line_string
    assert_equal column_string, ""
  end

  # it 'shlud save svg' do
  #   # puts  @tc.to_svg
  #   @tc.save_svg(@svg_path)
  #   assert File.exist?(@svg_path)
  #   # system("open #{@svg_path}")
  # end

end
