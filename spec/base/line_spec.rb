require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'create Line' do
  before do
    @line = Line.new
    @pdf_path = "/Users/mskim/test_data/line/output.pdf"
  end

  it 'shoud create Line' do
    assert_equal Line, @line.class
  end

  it 'shoud have @x2, and @y2' do
    assert_equal 0, @line.x
    assert_equal 0, @line.y
    assert_equal 100, @line.x2
    assert_equal 100, @line.y2
  end

  it  'should save pdf' do
    @line = Line.new(with:200, height:400)
    @line.save_pdf(@pdf_path)
    assert File.exist?(@pdf_path)
    system("open #{@pdf_path}")
  end
end
