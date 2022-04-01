module RLayout


  class CoverSpread
    attr_reader :project_path, :spread, :art_type # band, #image, #random_art
    attr_reader :width, :height, :updated, :color_1, :color_2
    def initialize(options={})
      @project_path = options[:project_path]
      FileUtils.mkdir_p(@project_path) unless File.exist?(@project_path)
      @width = options[:width] || 1100
      @height = options[:height] || 400
      @color_1 = options[:color_1] || 'yellow'
      @color_2 = options[:color_2] || 'gray'
      generate_pdf
      self
    end
    
    def layout_path
      @project_path + "/layout.rb"
    end

    def output_path
      @project_path + "/output.pdf"
    end

    def generate_pdf
      @update = false
      File.open(layout_path,'w'){|f| f.write generate_layout }
      @spread = eval(generate_layout)
      # end
      return unless is_dirty?
      @spread.save_pdf(output_path, jpg:true)
      @updated = true
    end

    def is_dirty?
      return true unless File.exist?(output_path)
      return true if File.mtime(layout_path) > File.mtime(output_path)
      return false
    end

    # def default_layout
    #   # before rotating 90 
    #   layout =<<~EOF
    #   RLayout::Container.new(width:#{@width}, height:#{@height}) do
    #     rect(fill_color: 'yellow', layout_length: 2)
    #     rect(fill_color: 'gray', layout_length: 1)
    #     relayout!
    #   end
    #   EOF
    # end


    def layout_without_image
      s =<<~EOF
      RLayout::Container.new(width:#{@width}, height:#{@height}) do
        rect(fill_color: '#{@color_1}', layout_length: 2)
        rect(fill_color: '#{@color_2}', layout_length: 1)
        relayout!
      end
  
      EOF
    end
  
    def layout_with_spread_image
      s =<<~EOF
      RLayout::Container.new(width:#{@width}, height:#{@height}) do
        image(image_path: '#{@cover_spread_image_path}', x:#{ -2}, Y: -2, width: #{@width + 4}, height: #{@height + 4})
      end
  
      EOF
    end
  
    def layout_with_page_image
      if cover_image_1_path_exist?  && cover_image_4_path_exist?
        s =<<~EOF
        RLayout::Container.new(width:#{@width}, height:#{@height}) do
          image(image_path:'#{@cover_image_4_path}', x:#{ -2}, Y: -2, width: #{@width/2 + 2}, height: #{@height + 4}, layout_member:false)
          image(image_path:'#{@cover_image_1_path}', x:#{@width/2}, Y: -2, width: #{@width/2 + 2}, height: #{@height + 4}, layout_member:false)
        end
        EOF
      elsif cover_image_1_path_exist?
        s =<<~EOF
        RLayout::Container.new(width:#{@width}, height:#{@height}) do
          rect(fill_color: '#{@color_1}', layout_length: 2)
          rect(fill_color: '#{@color_2}', layout_length: 1)
          relayout!
          image(image_path:'#{@cover_image_1_path}', x:#{@width/2}, Y: -2, width: #{@width/2 + 2}, height: #{@height + 4}, layout_member:false)
        end
        EOF
      elsif cover_image_4_path_exist?
        s =<<~EOF
        RLayout::Container.new(width:#{@width}, height:#{@height}) do
          rect(fill_color: '#{@color_1}', layout_length: 2)
          rect(fill_color: '#{@color_2}', layout_length: 1)
          relayout!
          image(image_path:'#{@cover_image_4_path}', x:#{ -2}, Y: -2, width: #{@width/2 + 2}, height: #{@height + 4}, , layout_member:false)
        end
        EOF
      end
    end
  
    def cover_spread_image_path_exist?
      if File.exist?("#{project_path}/spread.png")
        @cover_spread_image_path = "#{project_path}/spread.png"
        return true
      elsif File.exist?("#{project_path}/spread.jpg")
        @cover_spread_image_path = "#{project_path}/spread.jpg"
        return true
      end
      return false
    end

    def cover_image_1_path_exist?
      if File.exist?("#{project_path}/1.png")
        @cover_image_1_path = "#{project_path}/1.png"
        return true
      elsif File.exist?("#{project_path}/1.jpg")
        @cover_image_1_path = "#{project_path}/1.jpg"
        return true
      end
      return false
    end

    def cover_image_4_path_exist?
      if File.exist?("#{project_path}/4.png")
        @cover_image_4_path = "#{project_path}/4.png"
        return true
      elsif File.exist?("#{project_path}/4.jpg")
        @cover_image_4_path = "#{project_path}/4.jpg"
        return true
      end
      return false
    end

    def generate_layout
      if cover_spread_image_path_exist?
        layout_with_spread_image
        # File.open(layout_path, 'w'){|f| f.write layout_with_spread_image}
      elsif cover_image_1_path_exist? || cover_image_4_path_exist?
        layout_with_page_image
        # File.open(layout_path, 'w'){|f| f.write layout_with_page_image}
      else
        layout_without_image
        # File.open(layout_path, 'w'){|f| f.write layout_without_image}
      end
    end

  end

end