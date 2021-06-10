# GroupImageMaker
# Roll of GroupImageMaker is to detemine settings for GroupImage,
# given image data, width, and size.
# Determin the best value of column, row.

module RLayout
  class GroupImageMaker
    attr_reader :width, :height
    attr_reader :project_path, :output_path
    attr_reader :member_images 

    def initialize(options={})
      @project_path = options[:project_path]
      @output_path = @project + "/group_image.pdf"
      @width = options[:width]
      @height = options[:width]
      @member_images = options[:member_images]
      create_group_image
      self
    end

    def create_group_image
      result = GroupImage.new()
      result = GroupImage.new(@width, @height, @member_images)
      result.save_pdf_with_ruby(@output_path, :jpg=>true, :ratio => 2.0)
    end
  end
end