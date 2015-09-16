require File.dirname(__FILE__) + "/../spec_helper"

# describe 'NewsArticleMaker eval test' do
#   before do
#      
#     @news_box = RLayout::NewsArticleBox.new(nil, :grid_frame=>[4, 1, 3, 4], :grid_base=>[3, 4], :gutter=>10, :v_gutter=>10, :column_count=>3, :grid_width=>147.2214285714284, :grid_height=>131.9816666666666, :x=>0, :y=>0, :width=>461.66428571428514, :height=>557.9266666666664) do
#       heading
#       # float_image(:local_image=>"1.jpg", :grid_frame=>[0,0,1,1])
#       # float_image(:local_image=>"2.jpg", :grid_frame=>[0,1,1,1])
#     end
#   end
#   
#   it 'should create NewsArticleBox' do
#     assert @news_box.class == NewsArticleBox
#   end
#   
# end


describe 'creaet document with NewsArticleMaker' do
  before do
    article_path = "/Users/mskim/Dropbox/OurTownNews/2015-06-12/News/1.story"
    @maker = NewsArticleMaker.new(article_path: article_path)
    @news_box = @maker.news_article_box
    puts "@news_box.class:#{@news_box.class}"
    puts "@news_box.puts_frame:#{@news_box.puts_frame}"
    puts "@news_box.floats.length:#{@news_box.floats.length}"
    heading = @news_box.floats.first
    puts heading.class
    puts "heading.graphics.length:#{heading.graphics.length}"
  end
  
  it 'should create MagazineArticleScript' do
     assert @maker.class == NewsArticleMaker
  end
end

__END__
describe 'news_article reading stoy' do
  before do
    @path     = "/Users/mskim/Dropbox/OurTownNews/2015-06-12/News/1.story"
    @article  = NewsArticleMaker.make_layout(@path)
  end
    
  it 'should create layout file' do
    @layout_path = @path + "/layout.rb"
    assert File.exist?(@layout_path)
  end
end

