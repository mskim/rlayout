# encoding: utf-8
if RUBY_ENGINE == 'macruby'
  framework 'Quartz'
end
require 'yaml'

NEWS_PAPER_INFO = {
  name: "Ourtown News", 
  period: "daily", 
  paper_size: "A2"  
}

module RLayout
  
  class Newspaper
    attr_accessor :folder_path, :front_matter, :body_matter, :rear_matter
    attr_accessor :publication_info
    def initialize(folder_path)
      system("mkdir -p #{folder_path}") unless File.exists?(folder_path)
      info_path = folder_path + "/publication_info.yml"
      File.open(info_path, 'w'){|f| f.write(NEWS_PAPER_INFO.to_yaml)} unless File.exists?(info_path)
      self
    end
  end
  
  class NewspaperSection
    attr_accessor :folder_path, :issue_numner, :date, :section_name
    attr_accessor :articles, :section_template
    def initialize(publication_folder_path, options={})
      # create_folder
      copy_template
      self
    end
    
    def copy_template
      
    end
    
    def set_up
      
    end
    
    def merge_pdf_articles
      return unless RUBY_ENGINE == 'macruby'
      book_pdf = PDFDocument.new
      Dir.glob("#{@folder_path}/*.pdf") do |path|
        next if path =~ /book.pdf$/
        puts path
        url = NSURL.fileURLWithPath path
        pdf_chapter = PDFDocument.alloc.initWithURL url
        pdf_chapter.pageCount.times do |i|
          page = pdf_chapter.pageAtIndex i
          pdf_data = page.dataRepresentation
          page=PDFDocument.alloc.initWithData(pdf_data).pageAtIndex(0)
          book_pdf.insertPage(page, atIndex: book_pdf.pageCount)
        end
        puts "book_pdf.pageCount:#{book_pdf.pageCount}"
      end
      
      book_pdf.writeToFile("#{@folder_path}/book.pdf")
    end
        
    def process_markdown_files(options)
      options = {:starting_page_number=>1}
      Dir.glob("#{@folder_path}/*.markdown") do |m|
        result = convert_markdown2pdf(m, options)
        options[:starting_page_number] = result.next_chapter_starting_page_number if result
      end
    end
    
    def convert_markdown2pdf(markdown_path, options={})
      pdf_path = markdown_path.gsub(".markdown", ".pdf")
      title = File.basename(markdown_path, ".markdown")
      article = NewsArticle.new(:title =>title, :story_path=>markdown_path)
      article.save_pdf(pdf_path)
      article
    end
    
    def txt2markdown
      Dir.glob("#{@folder_path}/*.txt") do |m|
        convert_txt2markdown(m)
      end
    end
      
    def rtf2md(path)
      
    end
    
    def convert_txt2markdown(txt_path)
      txt_content = File.open(txt_path, 'r'){|f| f.read}
      title = File.basename(txt_path, ".txt")
      markdown_path = txt_path.gsub(".txt", ".markdown")
      yaml_header = <<EOF
---
title: #{title}
---

EOF
      with_yaml_header = yaml_header + "\n" + txt_content
      File.open(markdown_path, "w"){|f| f.write with_yaml_header}
      
    end
    
    def self.rtf2md(path)
      
    end
    
    def make_long_ditit(s,digits)
      s.rjust(digits,"0")
    end
    
    
    #TODO
    # breaks for digit that are already 3 digits or more
    # breaks for filenames with space 
    def normalize_filenames
      new_names = []
      Dir.glob("#{@folder_path}/*") do |m|
        basename = File.basename(m)
        if basename =~ /^\d+/
          r= /^\d*/
          matching_string = (basename.match r).to_s
          long_digit = make_long_ditit(matching_string, 3)
          new_base = basename.sub(matching_string, long_digit)
          new_path = @folder_path + "/#{new_base}"
          puts m
          puts new_path
          # system("mv #{m} #{new_path}")
        end
      end
      new_names
    end
  end  

end
