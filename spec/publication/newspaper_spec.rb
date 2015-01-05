require File.dirname(__FILE__) + "/../spec_helper"
# require File.dirname(__FILE__) + '/../../rlayout/publication/book'
# require File.dirname(__FILE__) + '/../../rlayout/publication/magazine'
# require File.dirname(__FILE__) + '/../../rlayout/publication/newspaper'

# describe 'create Newspaper' do
#   before do
#     @newspaper = Newspaper.new(nil)
#   end
#   
#   it ' should create Newspaper' do
#     @newspaper.must_be_kind_of Newspaper
#   end
#   
#   it 'should create publication_info' do
#     @newspaper.publication_info.must_be_kind_of Hash
#     @newspaper.publication_info[:width].must_equal 1190.55
#     @newspaper.publication_info[:height].must_equal 1683.78
#     puts @newspaper.publication_info
#   end
#   
# end

# describe 'create sample news_page' do
#   before do
#     @pdf_path = File.dirname(__FILE__) + "/../output/news_grid_sample.pdf"
#     @sample = NewspaperSection.sample_page(:output_path=>@pdf_path)
#   end
#   
#   it 'should save sample_page ' do
#     @sample.must_be_kind_of NewspaperSection
#     File.exists?(@pdf_path).must_equal true
#     system("open #{@pdf_path}")
#   end  
#   
# end



describe 'merge section pdf' do
  before do
    options = {
       :section_path => "/Users/mskim/Development/rails4/newsman/public/issues/1/1",
          :page_info => {
                    :x => 0,
                    :y => 0,
                :width => 1200.0,
               :height => 1800.0,
          :left_margin => 50,
           :top_margin => 50,
         :right_margin => 50,
        :bottom_margin => 50
      },
       :heading_info => {
                    :x => 0,
                    :y => 0,
                :width => 1200.0,
               :height => 150.0,
        :layout_length => 1,
        :image_fit_type=> IMAGE_FIT_TYPE_HORIZONTAL,
           :image_path => "/Users/mskim/Development/rails4/newsman/public/issues/1/1/section_heading.pdf"
      },
          :main_info => {
        :layout_length => 11
      },
      :articles_info => [
        {
                   :x => 752.72,
                   :y => 476.01,
               :width => 564.54,
              :height => 634.68,
          :image_path => "/Users/mskim/Development/rails4/newsman/public/issues/1/1/1.pdf"
        },
        {
                   :x => 0.0,
                   :y => 476.01,
               :width => 752.72,
              :height => 476.01,
          :image_path => "/Users/mskim/Development/rails4/newsman/public/issues/1/1/2.pdf"
        },
        {
                   :x => 0.0,
                   :y => 952.02,
               :width => 752.72,
              :height => 793.3499999999999,
          :image_path => "/Users/mskim/Development/rails4/newsman/public/issues/1/1/3.pdf"
        },
        {
                   :x => 752.72,
                   :y => 1110.6899999999998,
               :width => 564.54,
              :height => 634.68,
          :image_path => "/Users/mskim/Development/rails4/newsman/public/issues/1/1/4.pdf"
        },
        {
                   :x => 0.0,
                   :y => 0.0,
               :width => 1317.26,
              :height => 476.01,
          :image_path => "/Users/mskim/Development/rails4/newsman/public/issues/1/1/5.pdf"
        }
      ],
        :output_path => "/Users/mskim/Development/rails4/newsman/public/issues/1/1/section.pdf"
    }
    @section_page = NewspaperSection.new(nil,options).merge_pdf_articles
    @output_path= options[:output_path]
  end
  
  it 'should create pdf section' do
    File.exists?(@output_path).must_equal true
    system("open #{@output_path}")
  end
end
