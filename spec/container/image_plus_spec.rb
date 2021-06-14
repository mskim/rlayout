require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

# describe 'testing ImagePlus creation' do
#   before do
#     # @image_items = %w[1.jpg 2.jpg]
#     @pdf_path = "/Users/mskim/test_data/image_plus/output.pdf"
#     @image_path = "/Users/mskim/test_data/image_plus/소은숙.jpg"
#     @image_path = "/Users/mskim/test_data/image_plus/강은숙.jpg"
#     @g = ImagePlus.new(:width=>400, :height=>400,  image_path: @image_path, output_path: @ouput_path)

#   end

#   it 'should save pdf ImagePlus' do
#     @g.save_pdf(@pdf_path)
#     assert File.exist?(@pdf_path)
#     system "open #{@pdf_path}"
#   end
# end

describe 'testing ImagePlus ellipse' do
  before do
    # @image_items = %w[1.jpg 2.jpg]
    @image_path = "/Users/mskim/test_data/image_plus/강은숙.jpg"
    @pdf_path = "/Users/mskim/test_data/image_plus/output2.pdf"
    @ouput_path = "/Users/mskim/test_data/image_plus/output2.pdf"
    @g = ImagePlus.new(:width=>400, :height=>500, shape: 'circle', image_path: @image_path, output_path: @ouput_path, caption: "김소영")

  end

  it 'should save pdf ImagePlus' do
    @g.save_pdf(@pdf_path)
    assert File.exist?(@pdf_path)
    system "open #{@pdf_path}"
  end
end