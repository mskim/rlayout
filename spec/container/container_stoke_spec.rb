require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe 'container_stroke_drawing test' do
  before do
    @container = RLayout::Container.new(stroke_width: 1, x: 0, y:0, width: 300, height: 500, fill_color: 'white', top_margin: 50, bottom_margin: 50, left_margin: 50, right_margin: 50) do
      circle(stroke_width: 2, fill_color: 'blue')
      container(stroke_width: 2, fill_color: 'white', layout_direction: 'horizontal') do
        rectangle(stroke_width: 2, fill_color: 'red')
        rectangle(stroke_width: 2, fill_color: 'gray')
        rectangle(stroke_width: 2, fill_color: 'orange')
        rectangle(stroke_width: 2, fill_color: 'blue')
      end
      relayout!
    end
    @pdf_path = "#{ENV["HOME"]}/test_data/container/container_stoke.pdf"
    @svg_path = "#{ENV["HOME"]}/test_data/container/container_stoke.svg"
  end

  it 'should create Graphic object' do
    assert_equal Container, @container.class 
  end

  it 'should have top_margin ' do
    assert_equal 50, @container.top_margin
    assert_equal 50, @container.left_margin
    assert_equal 50, @container.right_margin
  end

  it 'should save pdf' do
    @container.save_pdf(@pdf_path)
    assert File.exist?(@pdf_path)
    @container.save_svg(@svg_path)
    assert File.exist?(@svg_path)
    system("open #{@pdf_path}")
    system("open #{@svg_path}")
  end
end
