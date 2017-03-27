require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'creating NewsImage ' do
  before do
    options= {
      :article_column => 3,
      :article_row => 3,
      :caption_title=> "이를면 내일 목포항으로 출발",
      :caption=> "약 2년 11개월 만에 모습을 들러낸 새월호가 26일 반잠수식 선박 위에서 선체속 물을 빼내고 있다. 배 안의 물과 기름을 제거하고 선체에 고정 작업을 마친 세월호는 이를먄 28일 목포신항으로 옮겨진다.",
    }
    @n_image              = NewsImage.new(options)
    @caption_title_text   = @n_image.caption_title_text
    @caption_object       = @n_image.caption_object
  end

  it "should create NewsImage class" do
    assert_equal NewsImage, @n_image.class
    assert_equal RLayout::Text, @caption_object.class
    assert_equal 1, @caption_object.text_height_in_lines
    assert_equal 0, @caption_object.space_after_in_lines
    # assert_equal 2, @caption_object.height_in_lines
  end

  it 'should create captiopn_title_text' do
    assert_equal Text, @n_image.caption_title_text.class
  end
end
