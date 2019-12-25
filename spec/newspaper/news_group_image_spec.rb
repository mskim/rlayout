require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'create NewsGroupImage with Image' do
    image_group_text = <<~EOF
      RLayout::NewsGroupImage.new() do
        news_image(image_path: "image_path1.jpg")
        news_image(image_path: "image_path2.jpg")
        news_image(image_path: "image_path3.jpg")
        news_image(image_path: "image_path4.jpg")
      end
    EOF
  before do
    puts image_group_text
    @news_image_group = eval(image_group_text)
  end

  it 'should create NewsGroupImage ' do
    assert_equal NewsGroupImage, @news_image_group.class
  end
end
