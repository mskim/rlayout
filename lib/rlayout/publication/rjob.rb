
module RLayout
  class RJob
    attr_accessor :path, :pgscript_path, :valid_job, :output_path
    def initialize(path, opttions={})
      @path = path
      @pgscript_path = @path + "/layout.rb"
      @output_path   = @path + "/QuickLook/Preview.pdf"
      @output_folder = @path + "/QuickLook"

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
      puts __method__
      pgscript = File.open(@pgscript_path, 'r'){|f| f.read}
      container = eval(pgscript)
      system("mkdir -p #{@output_folder}") unless File.exist?(@output_folder)
      container.save_pdf(@output_path)
    end
  end
end
