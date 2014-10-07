# encoding: utf-8

require 'yaml'
module RLayout
    
  
  class Book
    attr_accessor :folder_path, :front_matter, :body_matter, :rear_matter
    def initialize(folder_path)
      @front_matter = []
      @body_matter = []
      @rear_matter = []
      @folder_path = folder_path
      self
    end
    
    def markdown2pdf
      Dir.glob("#{@folder_path}/*.markdown") do |m|
        node = convert_markdown2pdf(m).book_node
        @body_matter << node.to_a
      end
      book_tree_path = @folder_path + "/chapter_tree.yml"
      File.open(book_tree_path, 'w'){|f| f.write @body_matter.to_yaml} 
    end
    
    def delete_markdown_files
      Dir.glob("#{@folder_path}/*.markdown") do |m|
        puts "deleting #{m}..."
        system("rm #{m}")
      end
      
    end
    
    def convert_markdown2pdf(markdown_path)
      pdf_path = markdown_path.gsub(".markdown", ".pdf")
      puts markdown_path
      title = File.basename(markdown_path, ".markdown")
      chapter = Chapter.new(:title =>title, :starts_left=>false, :story_path=>markdown_path)
      chapter.save_pdf(pdf_path)
      chapter
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
        
  end  

end
