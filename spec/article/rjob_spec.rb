require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'RJob with pgscript' do
  before do
    @script_path = "/Users/mskim/Documents/Customers/nail/namecard/output/강방자.rb"
    @rjob = RLayout::RJob.new(script_path: @script_path)
  end

  it 'should create rjob' do
    @rjob.created_object.must_be_kind_of Document
  end
end

__END__
describe 'RJob with pgscript' do
  before do
    @pdf_path = "/Users/mskim/rjob/rjob_sample.pdf"
    @jpg_path = "/Users/mskim/rjob/rjob_sample_1.jpg"
    @my_text= <<-EOF.gsub(/^\s*/, "")
    @output_path = "/Users/mskim/rjob/rjob_sample.pdf"
    @jpg         = true
    RLayout::Document.new(pdf_path: "#{@pdf_path}") do
      page do
        RLayout::Text.new(parent: self, text_string: "some_text", font_size: 12, font: "smGothicP-W70")
      end
      page
    end
    EOF
    @d= eval(@my_text)

    # @job = RJob.new(pdf_path: @pdf_path, pgscript: my_text,  has_pgscript: true)
  end

  it 'should create RJob' do
    @d.must_be_kind_of RLayout::Document
    @d.pdf_path.must_equal == @pdf_path
    @d.must_equal nil
  end

  # it 'should save rjob' do
  #   system("echo '#{@my_text}' | /Applications/rjob.app/Contents/MacOS/rjob ")
  #   # assert File.exist?(@pdf_path) == true
  #   assert File.exist?(@jpg_path) == true
  # end
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
