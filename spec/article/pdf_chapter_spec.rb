
require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe "PDFChapter" do
  before do
    @path = "/Users/mskim/demo_book_plan/front/Structure_And_"
    @pc   = PDFChapter.new(project_path: @path)
  end

  it 'should create PDFChapter' do
    # assert @sc.class == SpreadChapter
    # assert @doc.class == Document
    # assert @doc.pages.first.class == Page
    # assert @first_page.has_heading? == true
    # assert @first_page.main_box.class == TextBox
    assert @pc.class == RLayout::PDFChapter
  end

end
