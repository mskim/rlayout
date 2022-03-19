require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'create ChPage' do
  before do
    starting = Time.now
    @section_path =  "/Users/mskim/test_data/yearbook/yb_section/학급_3-1"
    @pdf_path =  "/Users/mskim/test_data/yearbook/yb_section/학급_3-1/output.pdf"
    @y = YbSection.new(section_path: @section_path, page_number: 12)
    ending = Time.now
    puts "It took #{ending - starting}!!!!"
  end

  it 'should create folders' do
    assert RLayout::YbSection,  @y.class
    assert_equal 7, @y.pages_path.length
  end

  it 'should create section_pdf' do
    assert RLayout::YbSection,  @y.class
    assert File.exist?(@y.section_pdf_path)
    system("open #{@y.section_pdf_path}")
  end
end
