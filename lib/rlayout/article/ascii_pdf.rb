# ascii_pdf
# generate pdf from acsciidotor document, 
# using set of pre-designed layout templates.

# Extending Asciidoctor for PDF layout
# floats_layout, 
#    allow_text_jump_over
# photo_section
# pdf_insert_section

if RUBY_ENGINE != 'rubymotion'
  require 'Asciidoctor'
end

module RLayout
  class AsciiPDF
    attr_accessor :adoc_path, :project_path, :ascii_doc, :output_path
    
    def initialize(adoc_path, options={})
      @adco_path    = adoc_path
      @project_path = File.dirname(@adoc_path)
      @ascii_doc    = Asciidoctor.load(@adoc_pqht)
      self
    end
    
    def self.pdf(adoc_path, options={})
      AsciiPDF.new(adoc_path).layout_pdf(options)
    end
    
    def layout_pdf(options={})
      
    end
  end
end

__END__
require 'minitest/autorun'

descirbe 'creare AsciiPDF' do
  let(:path){"/Users/mskim/asciidoc/sample1.adoc"}
  let(:adoc){AdciiPDF.new(path)}
  
  
end