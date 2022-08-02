require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

# describe 'NewsHeading Front' do
#   before do
#     @heading_path = "#{ENV["HOME"]}/test_data/news_publication/2022-04-20/page_01/heading"
#     @heading = NewsHeading.new(@heading_path, page_number: 1, issue_date:'2022-04-20')
#     @heading_pdf_path = @heading_path + "/output.pdf"
#   end

#   it 'should create NewsArticle' do
#     assert RLayout::NewsHeading,  @heading.class
#   end

#   it 'should save pdf' do
#     @heading.document.save_pdf(@heading_pdf_path)
#   end
# end

describe 'NewsHeading even' do
  before do
    @heading_path = "#{ENV["HOME"]}/test_data/news_publication/2022-04-20/page_02/heading"
    @heading = NewsHeading.new(@heading_path,  page_number: 2)
    @heading_pdf_path = @heading_path + "/output.pdf"
  end

  it 'should create NewsArticle' do
    assert RLayout::NewsHeading,  @heading.class
  end

  it 'should save pdf' do
    @heading.document.save_pdf(@heading_pdf_path)
  end
end

describe 'NewsHeading edd' do
  before do
    @heading_path   =  "#{ENV["HOME"]}/test_data/news_publication/2022-04-20/page_03/heading"
    @heading    = NewsHeading.new(@heading_path,  page_number: 3)
    @heading_pdf_path = @heading_path + "/output.pdf"
  end

  it 'should create NewsArticle' do
    assert RLayout::NewsHeading,  @heading.class
  end

  it 'should save pdf' do
    @heading.document.save_pdf(@heading_pdf_path)
  end
end