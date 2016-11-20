require 'minitest/autorun'
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '../..', 'lib')
require 'rlayout/graphic'
include RLayout

describe 'text_drawing test' do
  before do
    @text = Text.new(:text_string=> "This is text string.")
    @path = "/Users/Shared/rlayout/output/text_drawing_test.svg"
  end
  
  it 'should create Text object' do
    @text.must_be_kind_of Text
  end
  
  
  it 'should draw text' do
    @text.save_svg(@path)
    File.exist?(@path).must_equal true
    # system("open #{@path}")
  end
  
  
end
