require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe 'create InsideCover' do
  before do
    @document_path  = "#{ENV["HOME"]}/test_data/inside_cover"
    @pdf_path = "#{ENV["HOME"]}/test_data/inside_cover/output.pdf"
    h = {}
    h[:title] = '녹색의정원 Green Mansions'
    h[:author] = '윌리엄 허드슨 | 김선형 옮김'
    h[:width] = 354.33075
    h[:height] = 532.913448
    h[:left_margin] = 56.69292
    h[:top_margin] = 39.68504
    h[:right_margin] = 56.69292
    h[:bottom_margin] = 70.86615
    @inside_page = InsideCover.new(document_path: @document_path, **h)
  end

  it 'should create InsideCover' do
    assert_equal RLayout::InsideCover, @inside_page.class 
  end

  it 'should create InsideCover' do
    assert File.exist?(@pdf_path) 
    system "open #{@pdf_path}"
  end
end
