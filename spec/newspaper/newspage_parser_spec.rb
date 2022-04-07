require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'NewsToc' do
  before do
    @page_folder   =  "/Users/mskim/test_data/newspage_parser"
    FileUtils.mkdir_p(@article_path) unless File.exist?(@page_folder)
    @article_path = @page_folder + "/newspage.md"
    NewspageParser.save_sample_newspage(@article_path)
    @parser    = NewspageParser.new(article_path: @article_path)
  end

  it 'should create NewspageParser' do
    assert RLayout::NewspageParser,  @parser.class
  end

end