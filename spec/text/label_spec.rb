
$LOAD_PATH.unshift File.join(File.dirname(File.expand_path(__FILE__)), '../..', 'lib')

describe ' label creation' do
  before do
    @l = RLayout::Label.new(:text_string=>"T: 010-7468-8222")
  end

  it 'should create Label' do
    assert @l.class == Label
  end

  it 'should have label_text' do
    assert @l.label_text == "T:"
  end

  it 'should have label_length' do
    assert @l.label_length == 2
  end
end
