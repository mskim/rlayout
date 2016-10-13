require File.dirname(__FILE__) + "/../spec_helper"

describe "TOCChapter" do
  before do
    @path = "/Users/Shared/SoftwareLab/document_template/toc"
    @tc   = TOCChapter.new(project_path: @path)
    @doc  = @tc.document
    @toc  = @doc.pages.first.main_box
  end
  
  it 'should create TOCChapter' do
    assert @tc.class == TOCChapter
    assert @doc.class == Document
    assert @doc.pages.first.class == Page
    assert @toc.class == TocTable
  end
  
end