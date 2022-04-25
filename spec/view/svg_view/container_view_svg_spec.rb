require File.dirname(File.expand_path(__FILE__)) + "/../../spec_helper"

describe "create Container View" do
  before do
    @cv = Container.new(x:50, y:50, width: 600, height: 800) do
      container(fill_color: 'red', layout_direction: 'horizontal') do
        circle(fill_color: 'greed')
        circle(fill_color: 'yellow', layout_expand: [:width, :height])
        circle(fill_color: 'gray')
      end
      rect(fill_color: 'yellow', layout_expand: [:width, :height])
      rect(fill_color: 'green', layout_expand:[:width, :height])
      rect(fill_color: 'gray', layout_expand:[:width, :height])
      rect(fill_color: 'orange', layout_expand:[:width, :height])
      rect(fill_color: 'blue', layout_expand:[:width, :height])
      relayout!
    end

    @svg_path = "#{ENV["HOME"]}/test_data/svg/container_test.svg"
  end

  it 'should save_svg' do
    @cv.save_svg(@svg_path)
    # @cv.save_pdf(@svg_pdf)
    assert File.exist?(@svg_path)
    system "open #{@svg_path}"
  end
end


describe "create Container View" do
  before do
    @cv = Container.new(x:50, y:50, width: 600, height: 800) do
      container(fill_color: 'red', layout_direction: 'horizontal', left_margin: 100, right_margin: 100, stroke_thickess: 3) do
        circle(fill_color: 'greed')
        circle(fill_color: 'yellow', layout_expand: [:width, :height])
        circle(fill_color: 'gray')
      end
      relayout!
    end

    @svg_path = "#{ENV["HOME"]}/test_data/svg/container_test2.svg"
  end

  it 'should save_svg' do
    @cv.save_svg(@svg_path)
    @cv.save_pdf(@svg_pdf)
    assert File.exist?(@svg_path)
    system "open #{@svg_path}"
  end
end
