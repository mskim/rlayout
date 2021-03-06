require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'testing heading creation' do
  before do
    @con = RLayout::Container.new do
        heading(fill_color: "orange", title: "This is title")
    end
    @heading = @con.graphics.first
  end

  it 'should create Heading' do
    assert @heading.class == Heading
  end
end

describe 'testing heading creation' do
  before do
    @heading = Heading.new()
  end

  it 'should create heading' do
    @heading.must_be_kind_of Heading
  end

  it 'should have default values' do
    @heading.x.must_equal 0
    # @heading.y.must_equal 0
    @heading.width.must_equal 600
    # @heading.height.must_equal 100
  end
end


describe 'testing heading block' do
  before do
    @h = Heading.new() do
      title "This title looks great."
      subtitle "This is subtitle."
      leading "This is the leading"
      author "- Min Soo Kim"
    end
  end

  it 'should create heading' do
    @h.must_be_kind_of Heading
    @h.graphics.length.must_equal 4
  end

  it 'should have default types' do
    @h.title_object.must_be_kind_of Text
    @h.subtitle_object.must_be_kind_of Text
    @h.leading_object.must_be_kind_of Text
    @h.author_object.must_be_kind_of Text
  end

  it 'should save heading' do
    @svg_path = "/Users/Shared/rlayout/output/heading_test.svg"
    @h.save_svg(@svg_path)
    File.exist?(@svg_path).must_equal true
    # system "open #{@svg_path}"
    # @h.save_pdf(@pdf_path)
    # File.exist?(@pdf_path).must_equal true
  end

end
