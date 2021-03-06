require File.dirname(File.expand_path(__FILE__)) + "/spec_helper"
#


describe 'create page' do
  before do
    @p = Page.new()
    Container.new(:parent=> @p, :fill_color=>'green')
    Container.new(:parent=> @p, :fill_color=>'yellow')
    Container.new(:parent=> @p,:fill_color=>'orange')
    Container.new(:parent=> @p, :fill_color=>'gray')
    @p.relayout!
    @page_svg_test = "/Users/Shared/rlayout/output/page_svg_test.svg"
  end

  it 'should save svg' do
     @p.save_svg(@page_svg_test)
     assert File.exist?(@page_svg_test)
   end
end

describe 'create page with fixtures' do
  before do
    options = {}
    options[:header]     = true
    options[:footer]     = true
    options[:header]     = true
    options[:text_box]  = true
    @p = Page.new(options)
  end

  it 'should have header' do
    @p.must_be_kind_of Page
    @p.header.must_be_kind_of Header
    @p.footer.must_be_kind_of Footer
    @p.side_bar.must_be_kind_of SideBar
  end

  it 'should save svg' do
    @svg_path = "/Users/Shared/rlayout/output/page_fixture_test.svg"
    @p.save_svg(@svg_path)
    File.exist?(@svg_path).must_equal true
    # system("open #{@svg_path}")
  end

end

describe 'create right_side page  ' do
  before do
    options = {}
    # options[:header]     = true
    # options[:footer]     = true
    options[:text_box]  = true
    options[:left_page]  = false
    @p = Page.new(options)
  end

  it 'should have header' do
    @p.must_be_kind_of Page
    # @p.header_object.must_be_kind_of Header
    # @p.footer_object.must_be_kind_of Footer
    assert_nil  @p.side_bar_object
  end

  it 'should save svg' do
    @svg_path = "/Users/Shared/rlayout/output/page_fixture_right_side.svg"
    @p.save_svg(@svg_path)
    File.exist?(@svg_path).must_equal true
    # system("open #{@svg_path}")
  end
end
