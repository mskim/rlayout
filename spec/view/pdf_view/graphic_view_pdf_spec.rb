require File.dirname((File.expand_path __FILE__)) + "/../../spec_helper"

describe 'save pdf pdf in Ruby mode rectangle' do
  before do
    @g        = Graphic.new(x:30, y:30, width: 300, height: 400, fill_color: 'red')
    @pdf_path = "/Users/Shared/rlayout/output/graphic.pdf"
  end

  it 'should save rectagle' do
    @g.save_pdf(@pdf_path)
    assert File.exist?(@pdf_path)
    # system "open #{@pdf_path}"
  end
end

describe 'save pdf circle' do
  before do
    @circle = Circle.new(x:30, y:30, width: 300, height: 400, fill_color: 'green')
    @circle_pdf_path = "/Users/Shared/rlayout/output/circle.pdf"
  end

  it 'should save circle pdf in Ruby mode' do
    @circle.save_pdf(@circle_pdf_path)
    assert File.exist?(@circle_pdf_path)
    # system "open #{@circle_pdf_path}"
  end
end

describe 'save pdf in ruby mode' do
  before do
     @graphic   = Text.new(text_string: "Some text goes here!", font: "Helvetica", font_size: 12, x: 20, y:10, width: 100, height: 300, stroke_thickness: 5)
     @pdf_path = "/Users/Shared/rlayout/output/text_test.pdf"
  end

  it 'should save graphic pdf' do
    @graphic.save_pdf(@pdf_path)
    assert File.exist?(@pdf_path)
    system "open #{@pdf_path}"
  end
end
