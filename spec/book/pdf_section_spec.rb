require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe 'test PdfSection' do
  before do
    @section_path  = "#{ENV["HOME"]}/test_data/pdf_section"
    @pdf_path = @section_path + "/blank.pdf"
    @pdf_section = RLayout::PdfSection.new(@section_path)
    FileUtils.mkdir_p(@section_path) unless File.exist?(@section_path)
  end

  it 'should create PdfSection' do
    assert_equal RLayout::PdfSection, @pdf_section.class
  end

  it 'should save PdfSection' do
    assert File.exist?(@pdf_path) 
    system "open #{@pdf_path}"
  end
end
