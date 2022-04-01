require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'ramdom_graphic test' do
  before do
    # @g = Graphic.new(stroke_width: 1, x: 200, y:200, fill_color: 'red', stoke_color:'green')
    @project_path = "/Users/mskim/test_data/random_graphic"
    @random_g = RandomGraphic.new(project_path: @project_path)
    @pdf_path = "/Users/mskim/test_data/random_graphic/outout.pdf"
  end
  
  it 'should create RandomGraphic object' do
    assert_equal RandomGraphic, @random_g.class 
  end

  it 'should save PDF' do
    @random_g.save_pdf(@pdf_path, jpg:true)
    assert File.exist?(@pdf_path)
    system("open #{@pdf_path}")
  end

end
  