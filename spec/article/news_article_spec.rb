require File.dirname(__FILE__) + "/../spec_helper"
require File.dirname(__FILE__) + '/../../lib/rlayout/article/news_article'

describe 'load stoy' do
  before do
    options={
       :grid_frame => [4,3,3,4],
       :grid_width => 188.18,
       :grid_height => 158.67,
       :images => [
         {
           :image_path => "/Users/mskim/Development/rails4/newsman/public/issues/1/1/image/minsookim.jpg",
           :image_frame=> [0,0,1,1],
         },
         # {
         #   :image_path => "/Users/mskim/Development/rails4/newsman/public/issues/1/1/image/1.jpg",
         #   :image_frame=> [2,0,1,1],
         # } 
         ],
       :story_hash => {
         :heading => {
                 :title => "Mr. Kim Welcome!",
                :author => "some author",
              :subtitle => "This is some interesting article",
              :heading_columns => 2,
              :category => "news"
          },
          :body_markdown => "#### One is a first part of body. And some more text and some more of the text.\n\n#### Here is four text and some more of the text.\n\nThis is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here.\n\n#### In the year of 39, There are people singing.\n\nThere were singing about the hardship. And the lylics touched many of us. This is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here.\n\n#### And some more text and some more of the text.\n\nThis is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here.\n\n#### And some more text and some more\r\nof the text.\n\nThis is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here.\n\nThis is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here."
        },
      :output_path => "/Users/mskim/Development/rails4/newsman/public/issues/1/1/2.pdf"
    }
    @m = NewsArticle.new(nil, options) 
    @pdf_path ="/Users/mskim/Development/rails4/newsman/public/issues/1/1/2.pdf"
  end

  it 'should save loaded story' do
    File.exists?(@pdf_path).must_equal true
    system("open #{@pdf_path}")
  end
end

__END__

describe 'load stoy' do
  before do
      options = {
         :grid_frame => [4,3,3,4],
         :grid_width => 188.18,
        :grid_height => 158.67,
         :story_hash => {
                :heading => {
                   :category => "news",
                      :title => "Mr. Kim Welcome!",
                     :author => "some author",
                   :subtitle => "This is some interesting article",
            :heading_columns => 2
          },
          :body_markdown => "#### One is a first part of body. \n\n#### And some more text and some more\r\nof the text.\n\nThis is the body text for the story. And some more lines of text is here.\n\n#### And some more text and some more\r\nof the text.\n\nThis is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here.\n\n#### And some more text and some more\r\nof the text.\n\nThis is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here.\n\n#### And some more text and some more\r\nof the text.\n\nThis is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here.\n\n#### And some more text and some more\r\nof the text.\n\nThis is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here.\n\n\n\nThis is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here. This is the body text for the story. And some more lines of text is here."
        },
        :output_path => "/Users/mskim/Development/rails4/newsman/public/issues/1/1/1.pdf"
      }
    @m = NewsArticle.new(nil, options)
    @pdf_path ="/Users/mskim/Development/rails4/newsman/public/issues/1/1/1.pdf"
  end

  it 'should save loaded story' do
    File.exists?(@pdf_path).must_equal true
    system("open #{@pdf_path}")
  end
end


describe 'create NewsArticle with Image' do
  before do
    @story_path = "/Users/mskim/news_article/my_journey.markdown"
    options={
      story_path: @story_path, 
      heading_columns: 2, 
      grid_frame:       [0,0,3,2],
      grid_width:       200,
      grid_height:      200,
      gutter:           5,
      v_gutter:         0,
      left_margin:      10, 
      right_margin:     10, 
      top_margin:       10, 
      bottom_margin:    10,
    }
    @m = NewsArticle.new(nil, options)    
  end
  
  it 'should save' do    
    @pdf_path = File.dirname(__FILE__) + "/../output/news_article.pdf"
    @m.save_pdf(@pdf_path)
    File.exists?(@pdf_path).must_equal true
    system("open #{@pdf_path}")
  end
end
