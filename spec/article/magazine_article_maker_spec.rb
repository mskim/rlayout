require File.dirname(__FILE__) + "/../spec_helper"

describe 'create MagazineArticleMaker' do
  before do
    @path       = "~/magazine_article/first_article"
    @magazine_maker = MagazineArticleMaker.new(article_path: File.expand_path(@path))
  end
  
  it 'shuld create MagazineArticleMaker' do
    assert @magazine_maker.class == MagazineArticleMaker
    assert @magazine_maker.document.class == Document
    tb = @magazine_maker.document.pages.first.main_box
    assert tb.class == TextBox    
  end
  
end

__END__
# describe 'pgscript float_image' do
#   before do
#     @doc = RLayout::Document.new(:initial_page=>false) do
#       page do
#         main_text do
#           heading
#           float_image(local_image: "1.jpg", :grid_frame=> [0,0,1,1])
#           float_image(local_image: "2.jpg", :grid_frame=> [0,1,1,1])
#         end
#       end
# 
#       page do
#         main_text do
#           float_image(local_image: "1.jpg", :grid_frame=> [0,0,1,1])
#         end
#       end
#     end
#     
#     @document = @doc
#     puts "@document.pages.length:#{@document.pages.length}"
#     puts "@document.pages[0].graphics.length:#{@document.pages[0].graphics.length}"
#     puts "floats in the main box"
#     puts "@document.pages[0].main_box.class:#{@document.pages[0].main_box.class}"
#     puts "@document.pages[0].main_box.puts_frame:#{@document.pages[0].main_box.puts_frame}"
#     puts "@document.pages[0].main_box.floats.length:#{@document.pages[0].main_box.floats.length}"
#     @document.pages[0].main_box.floats.each do |graphic|
#       puts graphic.class
#       graphic.puts_frame
#       puts "graphic.grid_frame:#{graphic.grid_frame}"
#     end
#     
#   end
#   
#   it 'shoul place image' do
#     assert @doc.class == RLayout::Document
#   end
#   
# end

describe 'creaet document with MagazineArticleMaker' do
  before do
    article_path = "/Users/mskim/magazine_article/first_article"
    @maker = MagazineArticleMaker.new(article_path: article_path)
    @document = @maker.document
    puts "@document.pages.length:#{@document.pages.length}"
    puts "@document.pages[0].graphics.length:#{@document.pages[0].graphics.length}"
    puts "floats in the main box"
    puts "@document.pages[0].main_box.class:#{@document.pages[0].main_box.class}"
    puts "@document.pages[0].main_box.puts_frame:#{@document.pages[0].main_box.puts_frame}"
    puts "@document.pages[0].main_box.floats.length:#{@document.pages[0].main_box.floats.length}"
    heading = @document.pages[0].main_box.floats.first
    puts heading.class
    puts "heading.graphics.length:#{heading.graphics.length}"
  end
  
  it 'should create MagazineArticleScript' do
     assert @maker.class == MagazineArticleMaker
  end
  #  
  #  it 'should create Document' do
  #    assert @maker.document.class == RLayout::Document
  #  end
  #  
  #  it 'should create Pages' do
  #    assert @maker.document.pages.length == 2
  #    assert @maker.document.pages.first.heading.class == RLayout::Heading
  #  end
  
  # it 'should create Heading' do
  #   heading = @maker.document.pages.first.heading
  #   puts heading.class
  #   puts "heading.title_object.class:#{heading.title_object.class}"
  #   heading.graphics.each do |graphic|
  #     puts "graphic.class:#{graphic.class}"
  #   end
  # end
  
end