require File.dirname(File.expand_path(__FILE__)) + "/../../spec_helper"

describe "create RPageViewSVG" do
  before do
    @p = RPage.new(width: 600, height: 800) do

    end

    @svg_path = "/Users/mskim/test_data/svg/r_page/0001/page.svg"
  end

  it 'should save_svg' do
    @p.save_svg(@svg_path)
    # @p.save_pdf(@svg_pdf)
    assert File.exist?(@svg_path)
    system "open #{@svg_path}"
  end
end

