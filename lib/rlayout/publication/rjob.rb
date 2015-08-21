
module RLayout
  ProjectPath   = nil
  class RJob
    attr_accessor :path, :pgscript_path, :style_path, :valid_job, :output_path, :jpg
    def initialize(path, options={})
      
      @path           = path
      $ProjectPath    = @path
      @style_path     = @path + "/style.rb"
      
      if options[:input_path]
        @pgscript_path  = "#{options[:input_path]}"
      else
        @pgscript_path  = @path + "/layout.rb"
      end
      
      if options[:output_path]
        @output_path    = options[:output_path]
      else
        @output_path    = @path + "/output.pdf"
      end  
      
      if options[:pdf_path]
        @output_path = options[:pdf_path]
        @pdf_path    = options[:pdf_path]
      end
      
      if options[:jpg]
        @jpg=true
      end
      
      if @path =~/.rlayout$/
        @output_path    = @path + "/QuickLook/Preview.pdf"
        @output_folder  = @path + "/QuickLook"
        system("mkdir -p #{@output_folder}") unless File.exist?(@output_folder)
      end
      
      unless File.exist?(@pgscript_path)
        puts "#{@pgscript_path} does not exits!!!"
        return
      end
      container = nil
      pgscript  = File.open(@pgscript_path, 'r'){|f| f.read}
      container = eval(pgscript)
      # TODO add style to script
      # if File.exist?(@style_path)      
      #   hash = eval(File.open(@style_path, 'r'){|f| f.read})
      #   puts "hash:#{hash}"
      #   container = Container.new(nil, hash)
      # end
      container.save_pdf(@output_path, :jpg=>@jpg) if container
      self
    end
    
    # def process_job
    #   unless File.exist?(@pgscript_path)
    #     puts "#{@pgscript_path} does not exits!!!"
    #     return
    #   end
    #   container = nil
    #   pgscript  = File.open(@pgscript_path, 'r'){|f| f.read}
    #   container = eval(pgscript)
    #   # TODO add style to script
    #   # if File.exist?(@style_path)      
    #   #   hash = eval(File.open(@style_path, 'r'){|f| f.read})
    #   #   puts "hash:#{hash}"
    #   #   container = Container.new(nil, hash)
    #   # end
    #   container.save_pdf(@output_path, :jpg=>@jpg) if container
    # end
  end
end
