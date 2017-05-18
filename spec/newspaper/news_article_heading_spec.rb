require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"


describe 'creating HewsArticleHeading top_story heading' do
  before do
    options= {
      :top_story => true,
      :column_count => 3,
      'title'=> "Sample Title",
      'subtitle'=> "This is subtitle of the article",
      'author'=> "Min Soo Kim"
    }
    @nh = NewsArticleHeading.new(options)
    @title_object = @nh.title_object
    @subtitle_object = @nh.subtitle_object
  end

  it "should create NewsArticleHeading class" do
    assert_equal NewsArticleHeading, @nh.class
    assert_equal RLayout::Text, @title_object.class
    assert_equal 2, @title_object.space_before_in_lines
    assert_equal 5, @title_object.text_height_in_lines
    assert_equal 2, @title_object.space_after_in_lines
    assert_equal 9, @title_object.height_in_lines
    assert_equal RLayout::Text, @subtitle_object.class
    assert_equal 1, @subtitle_object.space_before_in_lines
    assert_equal 2, @subtitle_object.text_height_in_lines
    assert_equal 1, @subtitle_object.space_after_in_lines
    assert_equal 4, @subtitle_object.height_in_lines
  end

  it 'should have title and subtitle' do
    assert_equal 2, @nh.graphics.length
    assert_equal Text, @nh.title_object.class
    assert_equal Text, @nh.subtitle_object.class
  end
end

__END__

describe 'creating HewsArticleHeading with subject_head' do
  before do
    options= {
      :column_count => 3,
      'subject_head' => "현 정치상황",
      'title'=> "Sample Title",
      'subtitle'=> "This is subtitle of the article",
      'author'=> "Min Soo Kim"
    }
    @nh = NewsArticleHeading.new(options)
    @sunject_head_object  = @nh.subject_head_object
    @title_object         = @nh.title_object
    @subtitle_object      = @nh.subtitle_object
  end

  it "should create NewsArticleHeading class" do
    assert_equal NewsArticleHeading, @nh.class
    assert_equal 2, @nh.heading_columns
    assert_equal RLayout::Text, @title_object.class
    assert_equal 1, @title_object.space_before_in_lines
    assert_equal 3, @title_object.text_height_in_lines
    assert_equal 2, @title_object.space_after_in_lines
    assert_equal 6, @title_object.height_in_lines
    assert_equal NilClass, @subtitle_object.class
  end

  it 'should have title and subtitle' do
    assert_equal 2, @nh.graphics.length
    assert_equal Text, @nh.title_object.class
    assert_equal NilClass, @nh.subtitle_object.class
  end
end



describe 'creating HewsArticleHeading no subtitle in heading' do
  before do
    options= {
      column_count: 4,
      'title'=> "Sample Title",
      'subtitle'=> "This is subtitle of the article",
      'author'=> "Min Soo Kim"
    }
    @nh = NewsArticleHeading.new(options)
    @title_object = @nh.title_object
  end

  it "should create NewsArticleHeading class" do
    assert_equal NewsArticleHeading, @nh.class
    assert_equal RLayout::Text, @title_object.class
    assert_equal 4, @title_object.text_height_in_lines
  end

  it 'should have title only and no subtitle' do
    assert_equal 1, @nh.graphics.length
    assert_equal Text, @nh.graphics.first.class
  end
end

describe 'creating HewsArticleHeading with grid_width 3' do
  before do
    options= {
      column_count: 3,
      'title'=> "Sample Title",
      'subtitle'=> "This is subtitle of the article",
      'author'=> "Min Soo Kim"
    }
    @nh = NewsArticleHeading.new(options)
    @title_object = @nh.title_object
  end

  it "should create NewsArticleHeading class" do
    assert_equal NewsArticleHeading, @nh.class
    assert_equal RLayout::Text, @title_object.class
    assert_equal 4, @title_object.text_height_in_lines
  end
end

describe 'creating HewsArticleHeading with grid_width 4' do
  before do
    options= {
      column_count: 4,
      'title'=> "Sample Title",
      'subtitle'=> "This is subtitle of the article",
      'author'=> "Min Soo Kim"
    }
    @nh = NewsArticleHeading.new(options)
    @title_object = @nh.title_object
  end

  it "should create NewsArticleHeading class" do
    assert_equal NewsArticleHeading, @nh.class
    assert_equal RLayout::Text, @title_object.class
    assert_equal 4, @title_object.text_height_in_lines
  end
end
