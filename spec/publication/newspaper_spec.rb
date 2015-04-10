require File.dirname(__FILE__) + "/../spec_helper"



describe 'create sample news_page' do
  before do
    @section_path = "/Users/mskim/news_article/section1"
    @section = NewspaperSection.new(nil, :section_path=>@section_path)
  end
  
  # it 'should save sample_page ' do
  #   @section.must_be_kind_of NewspaperSection
  # end
  # 
  # it 'should set correct section_path' do
  #   @section.section_path.must_equal @section_path
  # end
  # 
  # it 'should set width ' do
  #   @section.paper_size.must_equal "A2"
  # end
  # 
  # it 'should create sample_articles' do
  #   @section.create
  #   File.exist?(@section_path + "/1.story.md")
  # end
  # 
  
  it 'should merge articles' do
    puts @section.grid_map
    @section.merge_article_pdf
  end
end
__END__


describe 'create Newspaper' do
  before do
    @newspaper = Newspaper.new(nil)
  end

  it ' should create Newspaper' do
    @newspaper.must_be_kind_of Newspaper
  end

  it 'should create publication_info' do
    @newspaper.publication_info.must_be_kind_of Hash
    @newspaper.publication_info[:width].must_equal 1190.55
    @newspaper.publication_info[:height].must_equal 1683.78
    puts @newspaper.publication_info
  end

end
describe 'create NewsArticle sample' do
  before do
    @news_section = NewsSection.new(nil, '/Users/mskim/news_article/sample')
    @sample = RLayout::NewsSection.make_sample_articles(5)
    @first_story_path = '/Users/mskim/news_article/sample/1.story.md'
  end

  it 'should create sample article' do
    File.exist?(@first_story_path).must_equal true
  end
end


describe 'merge section pdf' do
 before do
   options = {
      :section_path=>"/Users/mskim/Development/rails_tiny_apps/news_section/public/sections/1",
       :page_info=>{:x=>0, :y=>0, :width=>600, :height=>600, :left_margin=>50, :top_margin=>50, :right_margin=>50, :bottom_margin=>50},
       :main_info=>{:layout_length=>12},
       :articles_info=>
        [{:x=>0, :y=>0, :width=>3, :height=>1, :image_path=>"/Users/mskim/Development/rails_tiny_apps/news_section/public/sections/1/1.pdf"},
         {:x=>0, :y=>1, :width=>3, :height=>1, :image_path=>"/Users/mskim/Development/rails_tiny_apps/news_section/public/sections/1/2.pdf"},
         {:x=>0, :y=>2, :width=>1, :height=>1, :image_path=>"/Users/mskim/Development/rails_tiny_apps/news_section/public/sections/1/3.pdf"},
         {:x=>1, :y=>2, :width=>1, :height=>1, :image_path=>"/Users/mskim/Development/rails_tiny_apps/news_section/public/sections/1/4.pdf"},
         {:x=>2, :y=>2, :width=>1, :height=>1, :image_path=>"/Users/mskim/Development/rails_tiny_apps/news_section/public/sections/1/5.pdf"}],
       :output_path=>"/Users/mskim/Development/rails_tiny_apps/news_section/public/sections/1/section.pdf"}
   @section_page = NewspaperSection.new(nil,options).merge_article_pdf
   @output_path= options[:output_path]
 end

 it 'should create pdf section' do
   File.exists?(@output_path).must_equal true
   system("open #{@output_path}")
 end
end

__END__
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
    @section_page = NewspaperSection.new(nil,options).merge_article_pdf
    @output_path= options[:output_path]
  end

  it 'should create pdf section' do
    File.exists?(@output_path).must_equal true
    system("open #{@output_path}")
  end
end
