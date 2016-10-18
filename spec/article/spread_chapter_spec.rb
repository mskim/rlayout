require File.dirname(__FILE__) + "/../spec_helper"

describe "SpreadChapter" do
  before do
    @path       = "/Users/mskim/demo_book_plan/PART1_어법/01_주어와_동사의_파악"
    @path       = "/Users/mskim/Development/rails_rlayout/nr_english/public/1/6/8"
    @sc         = SpreadChapter.new(project_path: @path)
    @doc        = @sc.document
    @first_page = @sc.document.pages.first
  end
  
  it 'should create SpreadChapter' do
    # assert @sc.class == SpreadChapter
    # assert @doc.class == Document
    # assert @doc.pages.first.class == Page
    # assert @first_page.has_heading? == true
    # assert @first_page.main_box.class == TextBox
    @first_page.heading_object.class.must_equal RLayout::HeadingContainer
  end
  
end