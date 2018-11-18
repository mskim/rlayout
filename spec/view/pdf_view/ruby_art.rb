require File.dirname(File.expand_path(__FILE__)) + "/../../spec_helper"

describe 'save pdf art' do
  before do
    @c = Container.new(width: 600, height:800) do
      100.times do |i|
        r_x = (1..@width).to_a.sample
        r_y = (1..@height).to_a.sample
        r_width = (1..200).to_a.sample
        r_height = (1..200).to_a.sample
        color_1 = (0..100).to_a.sample
        color_2 = (0..100).to_a.sample
        color_3 = (0..100).to_a.sample
        color_4 = (0..50).to_a.sample
        thckness = (0..10).to_a.sample
        random_color = %w[red blue yellow gray lightGray pink pulple orange]
        rectangle(x:r_x, y:r_y, width: r_width, height: r_height, fill_color:random_color, stroke_width: thckness, stroke_sides:[1,1,1,1])
        # circle(x:r_x, y:r_y, width: r_width, height: r_height, fill_color:random_color)
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