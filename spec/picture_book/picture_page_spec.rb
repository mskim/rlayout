require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"
include RLayout

describe "create PictureSpreadPage" do
  before do
    @bg_image_path = "/Users/mskim/test_data/picture_book/02_03/1_2.jpg"
    @story_path = "/Users/mskim/test_data/picture_book/02_03/1.txt"
    @story = "여기는 사진에 대한 이야기 입니다.\n여기는 사진에 대한 이야기 입니다.\n여기는 사진에 대한 이야기 입니다."
    @page = PictureSpreadPage.new(bg_image_path: @bg_image_path, left_side:true, story: @story)
  end

  it 'should create PictureSpreadPage' do
    assert_equal PicturePage, @page.class
  end

  it 'should create 2 graphics' do
    assert_equal 2, @page.graphics.length
  end

  it 'should create bg_image' do
    assert_equal Image, @page.graphics.first.class
  end

  it 'should create story text' do
    assert_equal TitleText, @page.graphics[1].class
  end
end