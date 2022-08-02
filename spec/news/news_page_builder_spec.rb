require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'NewsPageBuilder' do
  before do
    @page_path   =  "#{ENV["HOME"]}/test_data/news_page_parser/2022-04-01/01"
    @builder =  NewsPageBuilder.new(@page_path)
  end

  it 'should create NewsPageBuilder' do
    assert RLayout::NewsPageBuilder,  @builder.class
  end

end