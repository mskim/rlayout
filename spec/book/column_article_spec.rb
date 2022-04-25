require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'create ColumnArticle' do
  before do
    @project_path = "#{ENV["HOME"]}/test_data/column_article"
    @pdf_path = "#{ENV["HOME"]}/test_data/column_article/output.pdf"
    @rakefile_path = "#{ENV["HOME"]}/test_data/column_article/Rakefile"
    @text_style_path = "#{ENV["HOME"]}/test_data/column_article/text_style.yml"
    @layout_path = "#{ENV["HOME"]}/test_data/column_article/layout.rb"
    @col = ColumnArticle.new(@project_path,  width: 300, custom_style:true)
  end

  it 'should create ColumnArticle' do
    assert_equal ColumnArticle, @col.class 
  end

  it 'should save rakefile' do
    @col.save_rakefile
    assert File.exist?(@rakefile_path)
  end

  it 'should save text_style' do
    assert File.exist?(@text_style_path)
  end

  it 'should save layout_rb' do
    @col.save_layout
    assert File.exist?(@layout_path)
  end

  it 'lines should save PDF' do
    assert File.exist?(@pdf_path)
    system "open #{@pdf_path}"
  end
end
