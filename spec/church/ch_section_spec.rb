require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'create ChSection' do
  before do
    starting = Time.now
    @section_path =  "/Users/mskim/test_data/church/ch_section"
    @pdf_path =  "/Users/mskim/test_data/church/ch_section/output.pdf"
    @y = ChSection.new(section_path: @section_path, page_number: 12)
    @y.save_pdf(@pdf_path)
    ending = Time.now
    puts "It took #{ending - starting}!!!!"
  end

  it 'should create folders' do
    assert RLayout::ChSection,  @y.class
  end

  it 'should create section_pdf' do
    assert File.exists?(@pdf_path)
    system("open #{@pdf_path}")
  end
end
