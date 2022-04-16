require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'NewsIssueBuilder' do
  before do
    @publication_path   =  "/Users/mskim/test_data/news_publication"
    FileUtils.mkdir_p(@publication_path) unless File.exist?(@publication_path)
    @date = '2022-04-20'
    @builder    = NewsIssueBuilder.new(publication_path: @publication_path, date: @date)
    # @isssue_plan_path = @publication_path + "/#{@date}_issue_plan.yml"
  end

  it 'should create NewsIssueBuilder' do
    assert RLayout::NewsIssueBuilder,  @builder.class
  end


end