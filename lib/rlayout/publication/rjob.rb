
module RLayout
  class RJob
    attr_accessor :path, :pgscript_path, :style_path, :valid_job, :output_path
    def initialize(path, opttions={})
      @path           = path
      @pgscript_path  = @path + "/layout.rb"
      @style_path     = @path + "/style.rb"
      @output_path    = @path + "/QuickLook/Preview.pdf"
      @output_folder  = @path + "/QuickLook"
      process_job
      self
    end

    def process_job
      # return if !File.exist?(@pgscript_path) && !
      container = nil
      if File.exist?(@pgscript_path)
        pgscript = File.open(@pgscript_path, 'r'){|f| f.read}
        #TODO add style to script
        container = eval(pgscript)
      elsif File.exist?(@style_path)
        hash = eval(File.open(@style_path, 'r'){|f| f.read})
        puts "hash:#{hash}"
        container = Container.new(nil, hash)
      end
      system("mkdir -p #{@output_folder}") unless File.exist?(@output_folder)
      container.save_pdf(@output_path) if container
    end
  end
end
