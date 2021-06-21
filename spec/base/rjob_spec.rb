require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe 'test Color named color' do
  
  before do
    @pdf_path = "/Users/mskim/test_data/rjob/output.pdf"
    @project_path = "/Users/mskim/test_data/rjob"
    @layout_path = "/Users/mskim/test_data/rjob/layout.rb"
    rlayout_rb =<<~EOF
      RLayout::Container.new(page_size: 'A4', fill_color:'red') do

      end
    EOF
    unless File.exists?(@project_path)
      FileUtils.mkdir_p(@project_path)
    end
    File.open(@layout_path, 'w'){|f| f.write rlayout_rb }
    h = {}
    h[:project_path] = @project_path
    h[:jpg] = true
    @g = RJob.new(h)
  end

  it 'should create RJob' do
    # @g.save_pdf(@pdf_path)
    assert File.exist?(@pdf_path)
    system("open #{@pdf_path}")
  end
end
