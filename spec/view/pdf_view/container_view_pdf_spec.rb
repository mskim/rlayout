require File.dirname(File.expand_path(__FILE__)) + "/../../spec_helper"

describe 'save pdf pdf in Ruby mode rectangle' do
  before do
    @c = Container.new(x:0, y:0, width: 600, height: 800) do
        image_path = "/Users/mskim/Pictures/1.jpg"
        rectangle(x:0, y:10, width: 100, height: 100, fill_color:'CMYK=0,100,0,0', stroke_width: 0.3, stroke_sides:[1,1,1,1])
        image(image_path:image_path, x:300, y:10, width: 100, height: 100, stroke_width: 0.3, stroke_sides:[1,1,1,1])
        circle(x:100, y:210, width: 100, height: 100, fill_color:'CMYK=100,,0,0')
        rectangle(x:200, y:410, width: 100, height: 100, fill_color:'CMYK=0,0,100,0', stroke_width: 5, stroke_sides:[0,1,0,1])
        rectangle(x:300, y:610, width: 100, height: 100, fill_color:'CMYK=0,0,0,100', stroke_width: 1, stroke_sides:[0,1,0,1])
      end
     @pdf_path = "/Users/Shared/rlayout/pdf_output/container.pdf"
  end

  it 'should save container' do
    @c.save_pdf(@pdf_path)
    assert File.exist?(@pdf_path)
    system "open #{@pdf_path}"
  end
end

__END__

describe 'save pdf art' do
  before do
    @c = Container.new(width: 600, height:800) do
      100.times do |i|
        r_x = (2..@width).to_a.sample
        r_x_2 = (2..@width).to_a.sample
        r_y = (2..@height).to_a.sample
        r_y_2 = (2..@height).to_a.sample
        r_width = (2..200).to_a.sample
        r_height = (2..200).to_a.sample
        color_1 = (0..100).to_a.sample
        color_2 = (0..100).to_a.sample
        color_3 = (0..100).to_a.sample
        color_4 = (0..50).to_a.sample
        thickness = (0..20).to_a.sample
        random_color = "CMYK=#{color_1},#{color_2},#{color_3},#{color_4}"
        random_color_2 = "CMYK=#{color_4},#{color_1},#{color_2},#{color_3}"
        rectangle(x:r_x, y:r_y, width: r_width, height: r_height, fill_color:random_color, stroke_width: thickness, stroke_sides:[1,1,1,1])
        circle(x:r_x_2, y:r_y, width: r_width, height: r_height, fill_color:random_color, stroke_width: thickness, stroke_color: random_color_2)
      end
    end
     @pdf_path = "/Users/Shared/rlayout/pdf_output/page.pdf"
  end

  it 'should save container' do
    @c.save_pdf(@pdf_path)
    assert File.exist?(@pdf_path)
    system "open #{@pdf_path}"
  end
end