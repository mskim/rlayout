require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe 'testing heading creation' do
  before do
    @heading = RHeading.new()
  end

  it 'should create heading' do
    @heading.must_be_kind_of RHeading
  end

  it 'should have default values' do
    @heading.x.must_equal 0
    @heading.width.must_equal 600
  end
end


describe 'testing heading block' do
  before do
    @h = RHeading.new() do
      title "This title looks great."
      subtitle "This is subtitle."
      leading "This is the leading"
      author "- Min Soo Kim"
    end
  end

  it 'should create heading' do
    @h.must_be_kind_of RHeading
    @h.graphics.length.must_equal 4
  end

  it 'should have default types' do
    @h.title_object.must_be_kind_of RTitleText
    @h.subtitle_object.must_be_kind_of RTitleText
    @h.leading_object.must_be_kind_of RTitleText
    @h.author_object.must_be_kind_of RTitleText
  end


end
