require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'create Pillar' do
  before do
    h = {}
    h[:width]       = 200
    h[:height]      = 500
    h[:pillar_path] = "/Users/mskim"
    h[:images]      = %w[1_1/story.pdf 1_2/story.pdf 1_3/story.pdf]
    @p = Pillar.new(h)
  end

  it 'should create Pillar' do
     assert_equal RLayout::Pillar, @p.class
     assert_equal 3, @p.graphics.length
  end

  it 'should create first image' do
    first_image = @p.graphics.first
    assert_equal RLayout::Image, first_image.class
    assert_equal first_image.image_path, '/Users/mskim/1_1/story.pdf'
    assert_equal 184, first_image.width
    assert_equal 122, first_image.height
  end

  it 'should create second image' do
    second_image = @p.graphics[1]
    assert_equal RLayout::Image, second_image.class
    assert_equal File.basename(second_image.image_path), 'story.pdf'
    assert_equal 122, second_image.y
    assert_equal 184, second_image.width
    assert_equal 122, second_image.height
    assert_equal MiniMagick::Image, second_image.image_object.class
  end
end