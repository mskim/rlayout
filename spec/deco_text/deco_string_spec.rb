require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'create DecoString' do
  before do
    @g = DecoChar.new(:x=>200, :y=>400, size: 20)
    @svg_path = "/Users/mskim/test_data/svg/deco_string_test.svg"
  end

  it 'should save svg' do
    @g.save_svg(@svg_path)
    assert File.exist?(@svg_path) == true
    system "open #{@svg_path}"
  end
end


