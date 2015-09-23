require File.dirname(__FILE__) + "/../spec_helper"

describe 'RJob with pgscript' do
  before do
    @pdf_path = "/Users/mskim/rjob_samples/doc_sample/output.pdf"
    my_text= <<-EOF
    RLayout::Document.new(pdf_path: "#{@pdf_path}") do
      page
      page
    end

    EOF
    @d= eval(my_text)
    
    # @job = RJob.new(nil, pdf_path: @pdf_path, pgscript: my_text,  has_pgscript: true)
  end
  
  it 'should create RJob' do
    @d.must_be_kind_of RLayout::Document
    assert @d.pdf_path == @pdf_path
    assert @d.jpg == nil
  end
end

# describe 'RJob Testing' do
#   before do
#     @path = "/Users/mskim/rjob_samples/SoftwareLab.rlayout"
#     @job = RJob.new(@path)
#   end
#   
#   it 'should create RJob' do
#     @job.must_be_kind_of RJob
#     @job.valid_job?.must_equal true
#   end
# end