
module RLayout
  class RJob
    attr_accessor :path, :pgscript_path, :valid_job, :output_path
    def initialize(path, opttions={})
      @path = path
      @pgscript_path = @path + "/layout.pgscript"
      @output_path = @path + "/QuickLook/Preview.pdf"
      process_job if valid_job?
      self
    end
    
    def valid_job?
      
      @valid_job = false
      return @valid_job unless File.exist?(@path)
      return @valid_job unless File.exist?(@pgscript_path)  
      @valid_job = true
    end
    
    def process_job
      pgscript = File.open(@pgscript_path, 'r'){|f| f.read}
      container = eval(pgscript)
      container.save_pdf(@output_path)
    end
  end
end
  
