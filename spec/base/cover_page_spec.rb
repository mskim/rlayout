

require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'create CoverPage' do
  def default_layout_rb
    <<~EOF
    RLayout::CoverPage.new(width: 300, height:500) do
      text_area(1,1,2,2, 'heading')
    end
    EOF
  end


  before do
    @p = eval(default_layout_rb)
  end

  it 'should create CoverPage' do
     assert_equal RLayout::CoverPage,  @p.class
  end

  it 'should find object with name == heading' do
    @text_area  = @p.find_by_name('heading')
    assert_equal RLayout::TextArea,  @text_area.class
  end

end


describe 'create page' do
  def default_layout_rb
    <<~EOF
    RLayout::CoverPage.new(width: 300, height:500, margin:20) do
      text_area(1,3,4,4, 'heading')
    end
    EOF
  end

  before do

    @content_hash = {}
    @content_hash[:title] = 'This is title'
    @content_hash[:subtitle] = "This is subtitle"
    @content_hash[:body] = "This is body"*10
    @project_path = "#{ENV["HOME"]}/test_data/cover_page"
    @pdf_path = @project_path + "/output.pdf"
    FileUtils.mkdir_p(@project_path) unless File.exist?(@project_path)
    @p = eval(default_layout_rb)
    @text_area  = @p.find_by_name('heading')
    @text_area.set_content(@content_hash)
    @p.save_pdf(@pdf_path)
  end

  it 'should create CoverPage' do
     assert File.exist?(@pdf_path)
     system("open #{@pdf_path}")
   end

end