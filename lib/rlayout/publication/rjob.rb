
module RLayout
  class RJob
    attr_accessor :path, :valid_job
    def initialize(path, opttions={})
      @path = path
      process_job if valid_job?
      self
    end
    
    def valid_job?
      @valid_job = false
      return @valid_job unless File.exist?(@path)
      return @valid_job unless File.exist?(@path + "/layout.yml")  
      @valid_job = true
    end
    
    def process_job
      puts "processing... #{@path} "
      Document.new(path: @path, output: true)
    end
  end
end
  
