require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'creating ProfileImage ' do
  before do
    profile_text =<<~EOF
    홍길동
    옛날대학교 사회학과 교수
    소설 역적 저자
    EOF

    options= {
      :width => 145,
      :profile_text=> profile_text,
    }
    @p_image            = ProfileImage.new(options)
    @profile_object     = @p_image.profile_object
    @image_object       = @p_image.image_object
  end

  it "should create ProfileImage class" do
    assert_equal ProfileImage, @p_image.class
    assert_equal RLayout::Text, @profile_object.class
    assert_equal 1, @profile_object.text_height_in_lines
    assert_equal 0, @profile_object.space_after_in_lines
    # assert_equal 2, @caption_object.height_in_lines
  end

end
