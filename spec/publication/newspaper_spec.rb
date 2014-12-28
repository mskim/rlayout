require File.dirname(__FILE__) + "/../spec_helper"
# require File.dirname(__FILE__) + '/../../rlayout/publication/book'
# require File.dirname(__FILE__) + '/../../rlayout/publication/magazine'
# require File.dirname(__FILE__) + '/../../rlayout/publication/newspaper'

describe 'merge_section_pdf' do
  before do
    options = {
      :path=>"/Users/mskim/Development/rails4/newsman/public/issues/1/1", 
      :page_info=>{:x=>0, :y=>0, :width=>1200, :height=>1600, :left_margin=>50, :top_margin=>50, :right_margin=>50, :bottom_margin=>50}, 
      :heading_info=>{:x=>0, :y=>0, :width=>1200, :height=>133, :image_path=>"/Users/mskim/Development/rails4/newsman/public/issues/1/1/section_heading.pdf"}, 
      :articles_info=>[
        {:x=>752.72, :y=>476.01, :width=>564.54, :height=>752.72, :image_path=>"/Users/mskim/Development/rails4/newsman/public/issues/1/1/1.pdf"}, 
        {:x=>0.0, :y=>476.01, :width=>752.72, :height=>564.54, :image_path=>"/Users/mskim/Development/rails4/newsman/public/issues/1/1/2.pdf"}, 
        {:x=>0.0, :y=>952.02, :width=>752.72, :height=>940.9000000000001, :image_path=>"/Users/mskim/Development/rails4/newsman/public/issues/1/1/3.pdf"}, 
        {:x=>752.72, :y=>1110.6899999999998, :width=>564.54, :height=>752.72, :image_path=>"/Users/mskim/Development/rails4/newsman/public/issues/1/1/4.pdf"}, 
        {:x=>0.0, :y=>0.0, :width=>1317.26, :height=>564.54, :image_path=>"/Users/mskim/Development/rails4/newsman/public/issues/1/1/5.pdf"}],
      :output_path=>"/Users/mskim/Development/rails4/newsman/public/issues/1/1/section.pdf"
    }
    @section_page = NewspaperSection.merge_pdf_articles(options)
    @output_path="/Users/mskim/Development/rails4/newsman/public/issues/1/1/section.pdf"
  end
  
  it 'should create pdf section' do
    File.exists?(@output_path).must_equal true
  end
end