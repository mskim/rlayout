$LOAD_PATH.unshift File.join(File.dirname(File.expand_path(__FILE__)), '../..', 'lib')

describe 'testing TitleText creation' do
  before do
    text_options = {text_string: "Some Head Text Here!", text_size: 16, text_color: "brown", x:10, y: 10, width: 400, height: 80}
    image_path = "/Users/mskim/demo_rjob/title_text/tree.jpg"
    options = { width: 500, height: 100, image_path: image_path, text_options: text_options}
    @tt = TitleText.new(options)
  end

  it 'should create TitleText' do
    assert @tt.class == TitleText
  end

  # it 'should create text_object' do
  #   assert @head.text_object.class == Text
  # end
  #
  # it 'should have frame_rect' do
  #   assert @head.text_object.frame_rect == [10,10,400,80]
  # end

end
