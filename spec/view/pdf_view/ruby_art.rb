require File.dirname(File.expand_path(__FILE__)) + "/../../spec_helper"

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
        cyan = (2..100).to_a.sample
        magenta = (2..100).to_a.sample
        yellow  = (2..100).to_a.sample
        color_1 = "CMYK=#{cyan},100,#{yellow},0"
        # color_2 = (0..100).to_a.sample
        color_2 = "CMYK=#{cyan},#{magenta},100,0"
        # color_3 = (0..100).to_a.sample
        color_3 = "CMYK=#{yellow},#{yellow},#{yellow},#{yellow}"
        # color_4 = (0..50).to_a.sample
        color_4 = "CMYK=20,50,#{yellow},0"

        thickness = (0..20).to_a.sample
        random_color = [color_1, color_2, color_3, color_4].sample
        random_color_2 = [color_4, color_1, color_2, color_3].sample
        random_color_2 = [color_3, color_4, color_1, color_2].sample
        random_color_3 = [color_2, color_3, color_4, color_1].sample
        random_color_4 = [color_2, color_4, color_1,  color_3].sample

        rectangle(x:r_x, y:r_y, width: r_width, height: r_height, fill_color:random_color, stroke_width: thickness, stroke_color: random_color_2, stroke_sides:[1,1,1,1])
        circle(x:r_x_2, y:r_y, width: r_width, height: r_height, fill_color:random_color_3, stroke_width: thickness, stroke_color: random_color_4)
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
