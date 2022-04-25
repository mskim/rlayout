

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
    RLayout::CoverPage.new(width: 300, height:500) do
      text_area(1,1,2,2, 'heading')
    end
    EOF
  end

  before do
    @project_path = "#{ENV["HOME"]}/test_data/cover_page"
    binding.pry
    @pdf_path = @project_path + "/output.pdf"
    FileUtils.mkdir_p(@project_path) unless File.exist?(@project_path)
    @p = eval(default_layout_rb)
    @p.save_pdf(@pdf_path)
  end

  it 'should create CoverPage' do
     assert File.exist?(@pdf_path)
     system("open #{@pdf_path}")
   end

end