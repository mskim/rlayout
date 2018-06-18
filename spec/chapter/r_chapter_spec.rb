require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe "create RChapter" do
  before do
    @project_path = "/Users/mskim/Development/chapter/01_chapter"
    @chapter     = RLayout::RChapter.new(project_path: @project_path)
  end

  it 'should create ChapterMaker' do
    @chapter.must_be_kind_of RChapter
  end
end
