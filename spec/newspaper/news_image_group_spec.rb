require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'create NewsImageGroup with Image' do
    image_group_text = <<~EOF
      RLayout::NewsImageGroup.new() do
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

  it 'should create NewsImageGroup ' do
    assert_equal NewsImageGroup, @news_image_group.class
  end
end
