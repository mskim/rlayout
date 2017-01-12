require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'create NewsPlan' do
  before do
    @issue_path = "/Users/Shared/Newspaper/Naeil2"
    @newsplan = NewsPlan.new(@issue_path)
  end

  it ' should create NewsPlan' do
    @newsplan.must_be_kind_of NewsPlan
  end

  # it 'should create new issue' do
  #   @newspaper.create_new_issue(issue_date: "2015-4-18", create_sections: true)
  #   issue_path = "/Users/Shared/Newspaper/Naeil/2015-4-18"
  #   File.exist?(issue_path).must_equal true
  # end
end
