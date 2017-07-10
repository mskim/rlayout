require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'testing HeadingContainer creation' do
  before do
    @cont = RLayout::Container.new do
      heading_container(fill_color: "orange", title: "This is title")
    end
    @heading = @cont.graphics.first
  end

  it 'should create HeadingContainer' do
    @heading.class.must_equal HeadingContainer
  end
end

describe 'testing heading creation' do
  before do
    @heading_c = RLayout::HeadingContainer.new(width: 500, height: 100, fill_color: 'clear') do
      image(local_image: "title_bg.pdf", fit_type: 4, width: 500, tag: "background")
      text("01",font_size: 60,  x: 35, text_color: 'blue', fill_color: 'clear', font: "Helvetica-Bold", tag: "number")
      text("Some\r text", font_size: 20, x: 140, width: 150, fill_color: 'clear', font: "Helvetica-Bold", tag: "title")
      text("subtitle text", font_size: 10, text_color: 'brown', x: 290, y: 25, width: 200, height: 30, fill_color: 'clear', font: "Helvetica", tag: "subtitle")
      text("주어가 길거나 문장이 복잡할 때에는 본동사를 먼저 찾고 이에 해당하는 주어를 찾는다. 이때, 동사 자리에 분사나 부정사가 잘못 들어가 있지는 않은지 확인한다.", font_size: 8, x: 290, y: 40, width: 200, height: 50, fill_color: 'clear', font: "Helvetica", tag: "leading")
    end

    @content_hash = {background: "heading_bg.pdf", number: "04", title: "Some Text", subtitle: "subtitle text", leading: "leading text "*3}

    @heading_c.set_content(@content_hash)
  end

  it 'should create HeadingContainer Items' do
    assert @heading_c.graphics.length == 5
    assert @heading_c.graphics[0].local_image == "title_bg.pdf"
    assert @heading_c.graphics[1].text_string == "01"
    assert @heading_c.graphics[2].text_string == "Some\r text"
    assert @heading_c.graphics[3].text_string == "subtitle text"
    assert @heading_c.graphics[4].text_string == "주어가 길거나 문장이 복잡할 때에는 본동사를 먼저 찾고 이에 해당하는 주어를 찾는다. 이때, 동사 자리에 분사나 부정사가 잘못 들어가 있지는 않은지 확인한다."
  end

end
