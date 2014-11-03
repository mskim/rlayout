# client.rb

require 'drb'
require File.dirname(__FILE__) + '/../rlayout'
require File.dirname(__FILE__) + '/../../lib/rlayout/article/chapter'
require File.dirname(__FILE__) + '/../../lib/rlayout/publication/book'

URI = "druby://127.0.0.1:8222"
puts "runing drb at 127.0.0.1:8222..."

class RLayoutServer
  
  def generate_book(path, options={})
    @book = RLayout::Book.new(path)
    @book.markdown2pdf        
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

