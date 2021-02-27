require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'create DecoChar' do
  before do
    @g = DecoChar.new(:x=>200, :y=>400, width:50, height: 50, size: 20, string: 'A')
    @svg_path = "/Users/mskim/test_data/svg/deco_char_test.svg"
  end

  it 'should save svg' do
    @g.save_svg(@svg_path)
    assert File.exist?(@svg_path) == true
    system "open #{@svg_path}"
  end


end