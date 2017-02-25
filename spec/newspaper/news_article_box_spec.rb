require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

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
