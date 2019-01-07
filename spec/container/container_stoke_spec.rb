require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe 'container_stroke_drawing test' do
  before do
    @g = RLayout::Container.new(stroke_width: 1, x: 0, y:0, width: 300, height: 500, fill_color: 'gray', top_margin: 50, bottom_margin: 50, left_margin: 50, right_margin: 50) do
      rectangle(stroke_width: 2, fill_color: 'yellow')
      container(stroke_width: 2, fill_color: 'white', layout_direction: 'horizontal') do
        rectangle(stroke_width: 2, fill_color: 'red')
        rectangle(stroke_width: 2, fill_color: 'gray')
        rectangle(stroke_width: 2, fill_color: 'orange')
      end
      rectangle(stroke_width: 1, fill_color: 'darkGray')
      relayout!
    end
    @path = "/Users/Shared/rlayout/output/container_stoke_drawing_test.svg"
    @pdf_path = "/Users/Shared/rlayout/output/container_stoke_drawing_test.pdf"
  end

  it 'should create Graphic object' do
    @g.must_be_kind_of Container
  end

  it 'should have top_margin ' do
    @g.top_margin.must_equal 50
    @g.left_margin.must_equal 50
    @g.right_margin.must_equal 50
  end

  it 'should save pdf' do
    @g.save_pdf(@pdf_path)
    File.exist?(@pdf_path).must_equal true
    system("open #{@pdf_path}")
  end
end
