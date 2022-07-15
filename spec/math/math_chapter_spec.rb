require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'create Math Chapter' do
  before do
    @document_path = "#{ENV["HOME"]}/test_data/chapter_with_math"
    @pdf_path  = @document_path +  "/chapter.pdf"
    FileUtils.mkdir_p(@document_path)  unless File.exist?(@document_path)
    h = {}
    h[:width] = SIZES['A5'][0]
    h[:height] = SIZES['A5'][1]
    h[:left_margin] = 50
    h[:top_margin] = 50
    h[:right_margin] = 50
    h[:bottom_margin] = 50
    h[:document_path] = @document_path
    h[:starting_page_number] = 14
    h[:jpg] = false
    h[:body_line_count] = 40
    @chapter  = RLayout::Chapter.new(**h)
    @document = @chapter.document
  end
  
  it 'should create LatexToken' do
    assert @chapter.class == Chapter
  end

  it 'should open pdf' do
    assert File.exist?(@pdf_path)
    system("open #{@pdf_path}")
  end
   
end
