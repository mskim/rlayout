module RLayout
  # Area serves as a place holder for item group.
  # Area is create with grid_frame, and area_type as an option
  # grid_frame is an array of x,y,width,height in parant grid value 

  # set_content
  # used to set Area's  content value from parent.
  # lays out given content with text_style
  # example
  # def person_area([0,2,4,3], [{name: 'Min Soo Kim}, {email: 'mskimsid@gmail.com'}])
  
  # defines person area with grid_frame

  class Area < Container
    attr_reader :grid_frame
    attr_reader :content
    attr_reader :v_alignment
    attr_reader :tag

    def initialize(options={})
      @grid_frame = options[:grid_frame]
      super
      @tag = options[:tag]
      @content = options[:content]
      # set_content if @content && @content != {}
      self
    end

    # set_content
    # set_content can be called at intialization time if @content is not nil
    # or called as batch mode with content is passed as options content: content
    # this is to support batch mode with  csv file.
    def set_content(new_content)
      @graphics = []
      y_position = 3
      new_content.each do |k,v|
        h = {}
        h[:parent] = self
        h[:style_name] = 'body'
        h[:style_name] = k.to_s if v
        h[:x] = 3
        h[:y] = y_position
        h[:text_string] = v
        object = TitleText.new(h)
        y_position += object.height
      end
    end
  end



end