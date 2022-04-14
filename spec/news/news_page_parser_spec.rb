require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'NewsPageParser' do
  before do
    news_paper_folder  = "/Users/mskim/test_data/news_page_parser"
    @page_md_path   =  "/Users/mskim/test_data/news_page_parser/2022-04-01_01.md"
    FileUtils.mkdir_p(news_paper_folder) unless File.exist?(news_paper_folder)
    page_info = {}
    page_info[:page_number] = 1
    page_info[:section_name] = '1면'
    page_info[:pillars] = [[4,2], [2,3]]
    page_info[:ad_type] = '5단통'
    page_info[:advertiser] = '삼성전자'
    NewsIssuePlan.save_page_md(page_info, @page_md_path) unless File.exist?(@page_md_path)
    @parser    = NewsPageParser.new(project_path:news_paper_folder, date: '2022-04-01',  page_number: 1)
  end

  it 'should create NewsPageParser' do
    assert RLayout::NewsPageParser,  @parser.class
  end

end