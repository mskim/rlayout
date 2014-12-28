# client.rb

require 'drb'
require File.dirname(__FILE__) + '/../rlayout'
require File.dirname(__FILE__) + '/../../lib/rlayout/publication/book'
require File.dirname(__FILE__) + '/../../lib/rlayout/publication/magazine'
require File.dirname(__FILE__) + '/../../lib/rlayout/publication/newspaper'

URI = "druby://127.0.0.1:8222"
puts "runing drb at 127.0.0.1:8222..."

class RLayoutServer
  
  # There are two cases
  # 1. options contains story_path, a path to stroy
  # 2. options contains story_path, a hash of story content
  def process_news_article(options)
    d = RLayout::NewsArticle.new(nil, options)    
    if d
      return "success"
    end
    'Failed'
  end
  
  def merge_news_section_pdf_articles(options)
    d = RLayout::NewspaperSection.merge_pdf_articles(options) 
    if d
      return "success"
    end
    'Failed'   
  end
  
  def generate_book(path, options={})
    @book = RLayout::Book.new(path)
    @book.process_markdown_files        
    if options[:merge_chapters]
      @book.merge_pdf_chpaters
    end
  end
  
  def rip_data(data)
    puts __method__
    if data[:klass] == 'Document'
      d= RLayout::DocumentViewMac.new(data)
    elsif data[:klass] == 'Page'
      d= RLayout::GraphicViewMac.with_data(data)
    end
    
    if data[:output_path]
      # write output
      d.save_pdf(data[:output_path], :output_tyes=>data[:output_types])
    end
    
    if d
      return "success"
    end
    'Failed'
  end
  
  # This is when sending path of pg_script
  def rip_pgscript(pg_script_path)
    # read the file, preproxess it into data and send it to rip_it(data)
  end
  
end

DRb.start_service(URI, RLayoutServer.new)
DRb.thread.join

