require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe 'create PartCover' do
  before do
    @project_path  = "/Users/mskim/test_data/part_cover"
    @pdf_path = @project_path + "/output.pdf"
    @part_cover = RLayout::PartCover.new(@project_path)
  end

  it 'should create Essay' do
    assert_equal RLayout::PartCover, @part_cover.class
  end

  it 'should create Seneca' do
    assert File.exist?(@pdf_path) 
    system "open #{@pdf_path}"
  end
end
