
require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe "create Mindrian" do
  before do 
    h = {}
    h[:max_level] = 3
    h[:width] = 600
    h[:height] = 800
    @project_path = "/Users/mskim/test_data/minsoolian"
    @pdf_path = "/Users/mskim/test_data/minsoolian/output.pdf"
    @min = Minsoolian.new(h)
  end

  it 'should create Mindrian' do
    assert_equal RLayout::Minsoolian, @min.class
  end

  it 'should save Mindrian' do
    FileUtils.mkdir_p(@project_path) unless File.exist?(@project_path)
    @min.save_pdf(@pdf_path)
    assert File.exist?(@pdf_path)
    system "open #{@pdf_path}"
  end
end