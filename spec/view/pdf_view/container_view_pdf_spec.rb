require File.dirname(File.expand_path(__FILE__)) + "/../../spec_helper"

describe 'save pdf pdf in Ruby mode rectangle in Page' do
  before do
    @c = Page.new(x:0, y:0, width: 600, height: 800, stroke_width: 1, stroke_color: [0,0,0,0]) do
        # rectangle(x:0, y:10, width: 100, height: 100, fill_color:[0.8,0.70,1,0], stroke_width: 3, stroke_sides:[1,1,1,1])
        # image_path = "/Users/mskim/Pictures/1.jpg"
        # image(image_path:image_path, x:300, y:10, width: 100, height: 100, stroke_width: 0.3, stroke_color: "CMYK=0,0,100,0", stroke_sides:[1,1,1,1])
        # circle(x:100, y:210, width: 100, height: 100, fill_color:[1,1,1,0.0])
        rectangle(x:0, y:210, width: 50, height: 100, fill_color:"CMYK=1000,0,0,0", stroke_width: 5, stroke_sides:[1,0,0,0], stroke_color:"CMYK=0,0,0,100")
        rectangle(x:100, y:210, width: 50, height: 100, fill_color:"CMYK=1000,0,0,0", stroke_width: 5, stroke_sides:[0,0,1,0], stroke_color:"CMYK=0,0,0,100")
        rectangle(x:250, y:210, width: 50, height: 100, fill_color:"CMYK=0,0,100,0", stroke_width: 5, stroke_color:"CMYK=0,0,0,100", stroke_sides:[0,1,0,0])
        rectangle(x:400, y:210, width: 50, height: 100, fill_color:"CMYK=0,0,100,0", stroke_width: 5, stroke_color:"CMYK=0,0,0,100", stroke_sides:[0,0,0,1])
      end
     @pdf_path = "/Users/Shared/rlayout/pdf_output/page.pdf"
  end

  it 'should save page' do
    @c.save_pdf(@pdf_path)
    assert File.exist?(@pdf_path)
    system "open #{@pdf_path}"
  end
end

describe 'save pdf pdf in Ruby mode rectangle in Container' do
  before do
    @c = Container.new(x:0, y:0, width: 600, height: 800, stroke_width: 1, stroke_color: [0,0,0,0]) do
        rectangle(x:0, y:210, width: 50, height: 100, fill_color:"CMYK=1000,0,0,0", stroke_width: 5, stroke_sides:[1,0,0,0], stroke_color:"CMYK=0,0,0,100")
        rectangle(x:100, y:210, width: 50, height: 100, fill_color:"CMYK=1000,0,0,0", stroke_width: 5, stroke_sides:[0,0,1,0], stroke_color:"CMYK=0,0,0,100")
        rectangle(x:250, y:210, width: 50, height: 100, fill_color:"CMYK=0,0,100,0", stroke_width: 5, stroke_color:"CMYK=0,0,0,100", stroke_sides:[0,1,0,0])
        rectangle(x:400, y:210, width: 50, height: 100, fill_color:"CMYK=0,0,100,0", stroke_width: 5, stroke_color:"CMYK=0,0,0,100", stroke_sides:[0,0,0,1])
      end
     @pdf_path = "/Users/Shared/rlayout/pdf_output/container.pdf"
  end

  it 'should save container' do
    @c.save_pdf(@pdf_path)
    assert File.exist?(@pdf_path)
    system "open #{@pdf_path}"
  end
end



