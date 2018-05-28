module RLayout

  class Jpg2svg
    attr_reader :jpg_path, :image_object, :output_folder

    def initialize(options={})
      @jpg_path             = options[:jpg_path]
      @output_folder        = options.fetch(:output_folder, nil)
      options[:image_path]  = @jpg_path
      @image_object         = Image.new(options)
      save_pdf
      self
    end

    def save_pdf
      if @output_folder
        # output_path =  @output_folder  + "/#{File.basename(@jpg_path,.jpg).pdf}"
      else
        output_path = @jpg_path.sub(/jpg$/, "pdf")
      end
      @image_object.save_pdf(output_path)
    end

    def self.batch(options)
      @source_path_path = options[:source_path]
      Dir.glob("#{@source_path_path}/*.jpg").each do |jpg_file|
        jpg_options               = {}
        jpg_options[:jpg_path]    = jpg_file
        jpg_options[:output_folder] = options[:output_folder] if options[:output_folder]
        Jpg2svg.new(jpg_options)
      end
    end
  end

end
