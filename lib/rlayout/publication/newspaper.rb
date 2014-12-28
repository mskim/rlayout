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
    attr_accessor :section_template
    def initialize(publication_folder_path, options={})
      # create_folder
      create_articles
      
      self
    end
    
    def create_articles
      @articles = []
      copy_template
    end
    
    def copy_template
      
    end
    
    def set_up
      
    end
    
    def base_pdf
      
    end
    
    def articles_info
      
    end
    
    # options = {
    #    options[:path]               : section_path
    #    options[:page_info]          : page options hash
    #    options[:heading_info]       : heading options hash
    #    options[:articles_info]      : articles_info list
    #    options[:output_path]
    #  }
    def self.merge_pdf_articles(options={})
      puts __method__
      puts "options:#{options}"
      section_page = Page.new(nil, options[:page_info])
      puts "section_page:#{section_page}"
      # section_heading_pdf = options[:path] + "/section_heading.pdf"
      # options[:image_path] = section_heading_pdf
      # place heading image
	    heading = Image.new(section_page, options[:heading_info]) 
	    puts "heading:#{heading}"
	    options[:articles_info].each_with_index do |article_info, i|
  	    # place each aritcles as Image 
	      Image.new(section_page, article_info)
	    end
	    if options[:output_path]
        section_page.save_pdf(options[:output_path])
      else
        puts "No options[:output_path]!!!"
      end
      section_page
    end
        
    def process_news_article_markdown_files(file_list)
      file_list.each do |m|
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
