require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

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
