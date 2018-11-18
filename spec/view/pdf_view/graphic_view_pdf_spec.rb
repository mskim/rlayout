require File.dirname(File.expand_path(__FILE__)) + "/../../spec_helper"


describe 'save pdf pdf in Ruby mode rectangle' do
  before do
    @g        = Graphic.new(x:0, y:0, width: 300, height: 300, fill_color:'CMYK=0,100,0,0', stroke_width: 5, stroke_sides:[0,1,0,1])
    @pdf_path = "/Users/Shared/rlayout/pdf_output/rectangle.pdf"
  end

  it 'should save rectagle' do
    @g.save_pdf(@pdf_path)
    assert File.exist?(@pdf_path)
    system "open #{@pdf_path}"
  end
end

__END__


describe 'save pdf in ruby mode' do
  before do
    @graphic   = Text.new(text_string: "Some text goes here!", font: "Helvetica", font_size: 12, x: 20, y:10, width: 300, height: 300, stroke_thickness: 5)
    @pdf_path = "/Users/Shared/rlayout/pdf_output/text_test.pdf"
  end

  it 'should save graphic pdf' do
    @graphic.save_pdf(@pdf_path)
    assert File.exist?(@pdf_path)
    system "open #{@pdf_path}"
  end
end


describe 'save pdf circle' do
  before do
    @circle = Circle.new(x:0, y:0, width: 300, height: 300, fill_color: 'CMYK=1000,0,0,0', stroke_width: 5)
    @circle_pdf_path = "/Users/Shared/rlayout/pdf_output/circle.pdf"
  end

  it 'should save circle pdf in Ruby mode' do
    @circle.save_pdf(@circle_pdf_path)
    assert File.exist?(@circle_pdf_path)
    system "open #{@circle_pdf_path}"
  end
end


describe 'save pdf in ruby mode' do
  before do
    #  @graphic   = Text.new(text_string: "Some text goes here!", font: "Helvetica", font_size: 12, x: 20, y:10, width: 300, height: 300, stroke_thickness: 5)
    image_path = "/Users/mskim/Development/rails5/style_guide/public/1/issue/2017-05-30/1/1/story.pdf"
    @graphic   = Image.new(image_path: image_path, x: 20, y:10, width: 300, height: 300, stroke_thickness: 5)
    @pdf_path = "/Users/Shared/rlayout/pdf_output/image_test.pdf"
  end

  it 'should save graphic pdf' do
    @graphic.save_pdf(@pdf_path)
    assert File.exist?(@pdf_path)
    system "open #{@pdf_path}"
  end
end

