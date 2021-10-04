require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'create TItleText with line break' do
  before do
    @text = "This\nand this is second line. and mote text"
    @title = TitleText.new(width: 500, height: 100, text_string: @text, style_name: 'title')
    @lines = @title.graphics
  end

  it 'should create two lines' do
    assert_equal 2, @lines.length
  end

  it 'should save pdf' do
    @pdf_path = "/Users/mskim/test_data/title_text/output.pdf"
    @title.save_pdf_with_ruby(@pdf_path)
    assert File.exist?(@pdf_path)
    system("open #{@pdf_path}")
  end

end

__END__
describe 'create TItleText' do
  before do
    @text = "This is a next with return\nand this is second line.\nand this is third line."
    @title = TitleText.new(width: 300, text_string: @text )
    @lines = @title.graphics
  end

  it 'should create TitleText' do
    assert_equal TitleText, @title.class
  end

  it 'should create three lines' do
    assert_equal @lines.length, 2
  end

end
