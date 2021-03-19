require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'text Text' do
  before do
    @t = Text.new(text_string: "This is string")
  end

  it 'should create Text' do
    assert_equal Text, @t.class
  end

  it 'should set default values' do
    assert_equal "This is string", @t.text_string
    assert_equal 'KoPubDotumPL', @t.font
    assert_equal 16, @t.font_size
    assert_equal 'black', @t.font_color
    assert_equal 'left', @t.text_alignment
    assert_equal 'normal', @t.text_style
  end

  it 'should save pdf' do
    @pdf_path = "/Users/mskim/test_data/text/output.pdf"
    @t.save_pdf(@pdf_path)
    assert File.exist?(@pdf_path)
  end
end

describe 'text left align Text' do
  before do
    @t = Text.new(width:200, text_string: "This is string", text_alignment: 'left')
  end

  it 'should save pdf' do
    @pdf_path = "/Users/mskim/test_data/text/left.pdf"
    @t.save_pdf(@pdf_path)
    assert File.exist?(@pdf_path)
    system("open #{@pdf_path}")
  end
end

describe 'text center align Text' do
  before do
    @t = Text.new(width:200, text_string: "This is string", text_alignment: 'center')
  end

  it 'should save pdf' do
    @pdf_path = "/Users/mskim/test_data/text/center.pdf"
    @t.save_pdf(@pdf_path)
    assert File.exist?(@pdf_path)
    system("open #{@pdf_path}")
  end
end

describe 'text right align Text' do
  before do
    @t = Text.new(width:200, text_string: "This is string", text_alignment: 'right')
  end

  it 'should save pdf' do
    @pdf_path = "/Users/mskim/test_data/text/right.pdf"
    @t.save_pdf(@pdf_path)
    assert File.exist?(@pdf_path)
    system("open #{@pdf_path}")
  end
end


describe 'text top v_align Text' do
  before do
    @t = Text.new(width:200, text_string: "This is string", text_alignment: 'left', v_alignment: 'top')
  end

  it 'should save pdf' do
    @pdf_path = "/Users/mskim/test_data/text/top.pdf"
    @t.save_pdf(@pdf_path)
    assert File.exist?(@pdf_path)
    system("open #{@pdf_path}")
  end
end

describe 'text center v_align Text' do
  before do
    @t = Text.new(width:200, text_string: "This is string", text_alignment: 'center', v_alignment: 'center')
  end

  it 'should save pdf' do
    @pdf_path = "/Users/mskim/test_data/text/v_center.pdf"
    @t.save_pdf(@pdf_path)
    assert File.exist?(@pdf_path)
    system("open #{@pdf_path}")
  end
end

describe 'text bottom v_align Text' do
  before do
    @t = Text.new(width:200, text_string: "This is string", text_alignment: 'right', v_alignment: 'bottom')
  end

  it 'should save pdf' do
    @pdf_path = "/Users/mskim/test_data/text/bottom.pdf"
    @t.save_pdf(@pdf_path)
    assert File.exist?(@pdf_path)
    system("open #{@pdf_path}")
  end
end