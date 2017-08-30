
require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'create Page from SVG' do
  before do
    path = "/Users/mskim/Development/rails5/style_guide/public/1/page_heading/text_2017-7-7/front_sample.svg"
    @svg = Canvas.from_svg(path)
    @first_group = @svg.graphics[4]
  end

  it 'should create Container from svg' do
    assert_equal Container, @svg.class
  end

  it 'Container should have graphic array' do
    assert_equal Array, @svg.graphics.class
    assert_equal 12, @svg.graphics.length
    assert_equal Rectangle, @svg.graphics.first.class
    assert_equal Rectangle, @svg.graphics[2].class
  end

  it 'should create group child' do
    assert_equal Container, @first_group.class
    assert_equal Array, @first_group.graphics.class
    assert_equal Text, @first_group.graphics.first.class
    puts " @first_group.graphics.first.to_svg:#{ @first_group.graphics.first.to_svg}"
    puts " @first_group.graphics.first.attributes:#{ @first_group.graphics.first.attributes}"
  end


end
