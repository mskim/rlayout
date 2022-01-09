require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'should process image_caption' do
  before do
    @current_page = RLayout::Container.new(width:400, height: 500) do
      line(x1: 0, y1:0, x2:300, y2:400, stroke_color: 'red', stoke_width: 1.0)
      line(x1: 0, y1:100, x2:300, y2:500, stroke_color: 'blue', stoke_width: 0.3)
    end    
    @pdf_path = "/Users/mskim/test_data/line/output.pdf"
  end

  it 'should save pdf page with line' do
    @current_page.save_pdf_with_ruby(@pdf_path)
    assert File.exist?(@pdf_path)
    system("open #{@pdf_path}")
  end
end