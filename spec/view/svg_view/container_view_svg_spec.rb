require File.dirname(File.expand_path(__FILE__)) + "/../../spec_helper"

describe "create Container View" do
  before do
    @cv = Container.new(width: 600, height: 800, margin: 10) do
      container(fill_color: 'red', layout_direction: 'horizontal') do
        circle(fill_color: 'greed')
        circle(fill_color: 'yellow', layout_expand: [:width, :height])
        circle(fill_color: 'gray')
      end
      rect(fill_color: 'gray', layout_expand: [:width, :height])
      rect(fill_color: 'orange', layout_expand:[:width, :height])
      rect(fill_color: 'gray', layout_expand:[:width, :height])
      rect(fill_color: 'orange', layout_expand:[:width, :height])
      rect(fill_color: 'gray', layout_expand:[:width, :height])
      relayout!
    end
    @svg_path = "/Users/Shared/rlayout/output/container_test.svg"
    # @svg_pdf = "/Users/Shared/rlayout/output/container_test.pdf"
  end


  it 'should save_svg' do
    @cv.save_svg(@svg_path)
    # @cv.save_pdf(@svg_pdf)
    assert File.exist?(@svg_path)
    system "open #{@svg_path}"
  end
end
