
require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'create Newspaper' do
  before do
    @newspaper = Newspaper.new(name: "OurNews", create_sections: false)
  end

  it ' should create Newspaper' do
    @newspaper.must_be_kind_of Newspaper
  end

  it 'should create new issue' do
    @newspaper.create_new_issue(issue_date: "2015-4-18", create_sections: true)
    issue_path = "/Users/Shared/Newspaper/Naeil/2015-4-18"
    File.exist?(issue_path).must_equal true
  end
end


# describe 'create Newspaper' do
#   before do
#     @newspaper = Newspaper.new(name: "Naeil")
#   end
#
#   it ' should create Newspaper' do
#     @newspaper.must_be_kind_of Newspaper
#   end
#
#   it 'should create new issue' do
#     @newspaper.create_new_issue(:issue_date =>"2015-4-18")
#     issue_path = "/Users/Shared/Newspaper/Naeil/2015-4-18"
#     File.exist?(issue_path).must_equal true
#   end
# end
#
#
#
# describe 'change section layout' do
#   before do
#     @path = '/Users/Shared/Newspaper/OurTimes/2015-4-16/culture'
#     @section = RLayout::NewspaperSection.change_section_layout(@path, grid_key: "7x12/6")
#   end
#
#   it 'should change section' do
#     @section
#   end
# end
#
#
# describe 'update NewsBoxMaker metadata' do
#   before do
#     @path = '/Users/Shared/Newspaper/OurTimes/2015-4-16/culture/2.story.md'
#   end
#
#   it 'should update metada of story' do
#     metadata = {'grid_frame' =>[0,0,1,1]}
#     Story.update_metadata(@path, metadata)
#   end
#
# end
#
#
#
#
# describe 'create sample news_page with heading' do
#   before do
#     @section_path = "/Users/mskim/news_article/section8"
#     @section = NewspaperSection.new(:section_path=>@section_path, :has_heading=> true)
#     @section.create
#   end
#
#   it 'should create heading.pdf' do
#     File.exist?(@section_path + "/heading.pdf").must_equal true
#   end
# end
#
# # describe 'create sample news_page' do
# #   before do
# #     @section_path = "/Users/mskim/news_article/section9"
# #     @section = NewspaperSection.new(:section_path=>@section_path)
# #     @section.create
# #   end
#
#   # it 'should save NewspaperSection ' do
#   #   @section.must_be_kind_of NewspaperSection
#   # end
#   #
#   # it 'should set correct section_path' do
#   #   @section.section_path.must_equal @section_path
#   # end
#   #
#   # it 'should set width ' do
#   #   @section.page_size.must_equal "A2"
#   # end
#   #
#   # it 'should create sample_articles' do
#   #   File.exist?(@section_path + "/1.story.md")
#   # end
#   # it 'should create heading.pdf' do
#   #   File.exist?(@section_path + "/heading.pdf")
#   # end
#
#
#   #
#
#   # it 'should merge articles' do
#   #   puts @section.grid_map
#   #   @section.merge_article_pdf
#   # end
# # end
#
#
# describe 'create NewsBoxMaker sample' do
#   before do
#     @news_section = NewsSection.new('/Users/mskim/news_article/sample')
#     @sample = RLayout::NewsSection.make_sample_articles(5)
#     @first_story_path = '/Users/mskim/news_article/sample/1.story.md'
#   end
#
#   it 'should create sample article' do
#     File.exist?(@first_story_path).must_equal true
#   end
# end
#
#
# describe 'merge section pdf' do
#  before do
#    options = {
#       :section_path=>"/Users/mskim/Development/rails_tiny_apps/news_section/public/sections/1",
#        :page_info=>{:x=>0, :y=>0, :width=>600, :height=>600, :left_margin=>50, :top_margin=>50, :right_margin=>50, :bottom_margin=>50},
#        :main_info=>{:layout_length=>12},
#        :articles_info=>
#         [{:x=>0, :y=>0, :width=>3, :height=>1, :image_path=>"/Users/mskim/Development/rails_tiny_apps/news_section/public/sections/1/1.pdf"},
#          {:x=>0, :y=>1, :width=>3, :height=>1, :image_path=>"/Users/mskim/Development/rails_tiny_apps/news_section/public/sections/1/2.pdf"},
#          {:x=>0, :y=>2, :width=>1, :height=>1, :image_path=>"/Users/mskim/Development/rails_tiny_apps/news_section/public/sections/1/3.pdf"},
#          {:x=>1, :y=>2, :width=>1, :height=>1, :image_path=>"/Users/mskim/Development/rails_tiny_apps/news_section/public/sections/1/4.pdf"},
#          {:x=>2, :y=>2, :width=>1, :height=>1, :image_path=>"/Users/mskim/Development/rails_tiny_apps/news_section/public/sections/1/5.pdf"}],
#        :output_path=>"/Users/mskim/Development/rails_tiny_apps/news_section/public/sections/1/section.pdf"}
#    @section_page = NewspaperSection.new(nil,options).merge_article_pdf
#    @output_path= options[:output_path]
#  end
#
#  it 'should create pdf section' do
#    File.exist?(@output_path).must_equal true
#    system("open #{@output_path}")
#  end
# end
#
#
# describe 'merge section pdf' do
#   before do
#     options = {
#        :section_path => "/Users/mskim/Development/rails4/newsman/public/issues/1/1",
#           :page_info => {
#                     :x => 0,
#                     :y => 0,
#                 :width => 1200.0,
#                :height => 1800.0,
#           :left_margin => 50,
#            :top_margin => 50,
#          :right_margin => 50,
#         :bottom_margin => 50
#       },
#        :heading_info => {
#                     :x => 0,
#                     :y => 0,
#                 :width => 1200.0,
#                :height => 150.0,
#         :layout_length => 1,
#         :image_fit_type=> IMAGE_FIT_TYPE_HORIZONTAL,
#            :image_path => "/Users/mskim/Development/rails4/newsman/public/issues/1/1/section_heading.pdf"
#       },
#           :main_info => {
#         :layout_length => 11
#       },
#       :articles_info => [
#         {
#                    :x => 752.72,
#                    :y => 476.01,
#                :width => 564.54,
#               :height => 634.68,
#           :image_path => "/Users/mskim/Development/rails4/newsman/public/issues/1/1/1.pdf"
#         },
#         {
#                    :x => 0.0,
#                    :y => 476.01,
#                :width => 752.72,
#               :height => 476.01,
#           :image_path => "/Users/mskim/Development/rails4/newsman/public/issues/1/1/2.pdf"
#         },
#         {
#                    :x => 0.0,
#                    :y => 952.02,
#                :width => 752.72,
#               :height => 793.3499999999999,
#           :image_path => "/Users/mskim/Development/rails4/newsman/public/issues/1/1/3.pdf"
#         },
#         {
#                    :x => 752.72,
#                    :y => 1110.6899999999998,
#                :width => 564.54,
#               :height => 634.68,
#           :image_path => "/Users/mskim/Development/rails4/newsman/public/issues/1/1/4.pdf"
#         },
#         {
#                    :x => 0.0,
#                    :y => 0.0,
#                :width => 1317.26,
#               :height => 476.01,
#           :image_path => "/Users/mskim/Development/rails4/newsman/public/issues/1/1/5.pdf"
#         }
#       ],
#         :output_path => "/Users/mskim/Development/rails4/newsman/public/issues/1/1/section.pdf"
#     }
#     @section_page = NewspaperSection.new(nil,options).merge_article_pdf
#     @output_path= options[:output_path]
#   end
#
#   it 'should create pdf section' do
#     File.exist?(@output_path).must_equal true
#     system("open #{@output_path}")
#   end
# end
