require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe 'testing r_cover creation' do
  before do
    @r_cover = RCover.new()
  end

  it 'should create r_cover' do
    @r_cover.must_be_kind_of RCover
  end

  it 'should have default values' do
    @r_cover.x.must_equal 0
    @r_cover.width.must_equal 600
  end
end


describe 'testing r_cover block' do
  before do
    @h = RCover.new() do
      title "This title looks great."
      subtitle "This is subtitle."
      leading "This is the leading"
      author "- Min Soo Kim"
    end
  end

  it 'should create r_cover' do
    assert_equal RLayout::RCover, @h.class 
    assert_equal 4, @h.graphics.length
  end

  it 'should have default types' do
    assert_equal TitleText, @h.title_object.class
    assert_equal TitleText, @h.subtitle_object.class
    assert_equal TitleText, @h.leading_object.class
    assert_equal TitleText, @h.author_object.class
    assert_equal TitleText, @h.logo_object.class
  end

end
