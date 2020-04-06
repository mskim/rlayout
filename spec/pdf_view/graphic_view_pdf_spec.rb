require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe "Generate PDF from Graphic"do
  before do
    @layout = RLayout::Container.new(width:500, height:500, fill_color: 'red', stroke_sides: [1,1,1,1], stroke_thickness: 0.3) do
        rect(x:100, y:100, width:100, height:100, fill_color:'yellow', stroke_sides: [0,1,1,1], stroke_thickness: 0.3)
    end
    @pdf_path = File.dirname(__FILE__) + "/.sample.pdf"

    @layout.save_pdf(@pdf_path)
  end
  it 'should create pdf' do
    assert File.exists?(@pdf_path)
  end

end