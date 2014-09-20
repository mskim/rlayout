# client.rb

require 'drb'
require 'rlayout'
URI = "druby://127.0.0.1:8222"
puts "runing drb at 127.0.0.1:8222..."

class MacRip
  # {
  #   :klass            => klass_name,
  #   :output_path      => "output/path"
  #   :output_types     => [pdf, jpg, thumbnail]
  # }  
  
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

DRb.start_service(URI, MacRip.new)
DRb.thread.join

