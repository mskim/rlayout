require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'NewsPageParser' do
  before do
    @page_folder   =  "/Users/mskim/test_data/news_page_parser/2022-04-01"
    FileUtils.mkdir_p(@page_folder) unless File.exist?(@page_folder)
    @page_md_path = @page_folder + "/01.md"
    NewsPageParser.save_sample_newspage(@page_md_path)
    @parser    = NewsPageParser.new(page_md_path: @page_md_path)
  end

  it 'should create NewsPageParser' do
    assert RLayout::NewsPageParser,  @parser.class
  end

end