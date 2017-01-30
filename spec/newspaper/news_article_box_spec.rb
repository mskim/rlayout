require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'create NewsArticleBox' do
  before do
    @nab  = NewsArticleBox.new()
  end

  it 'shold create NewsArticleBox' do
    assert @nab.class == NewsArticleBox
  end

  it 'shold create TextColumn' do
    assert @nab.graphics.length == 1
    assert @nab.graphics[0].class == TextColumn
  end

end
