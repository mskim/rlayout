
module RLayout
  class NewsPagePdfMerger < Container
    attr_reader :page_path, :page_config

    def initialize(options={})
      @page_path = options[:page_path]
      @publication_info = YAML::load_file(publication_info_path)
      @page_config = YAML::load_file(page_config_path)
      options.merge!(@publication_info)
      @body_line_height = @publication_info[:body_line_height] #  14.1222

      super
      layout_page_heading
      layout_ad_box if @ad_box_rect
      merge_article_pdf
      self
    end

    def publication_path
      File.dirname(@page_path)
    end

    def publication_info_path
      publication_path + "/publication_info.yml"
    end

    def page_config_path
      @page_path + "/config.yml"
    end

    def output_path
      @page_path + "/section.pdf"
    end

    def heading_path
      @page_path + "/heading"
    end

    def heading_pdf_path
      heading_path + "/output.pdf"
    end

    def layout_page_heading
      # width: 1028.9763779528, height: 139.0326207874
      Image.new(parent:self, x: 42, y: 42, width:1028.9763779528, heihgt: 139.0326207874, image_path: heading_pdf_path)

      puts __method__
    end

    def layout_ad_box
      puts __method__
    end

    def merge_article_pdf
      pillars = @page_config[:pillar_map]
      @column_count = @page_config[:pillar_width].map{|f| f}.reduce(:+) # TODO
      @column_width = @width/@column_count
      @pillar_x_grid = 0
      pillars.each_with_index do |pillar, pillar_index|
        # TODO should not have empty array fix this!!!!!
        next if pillar == []
        pillar_x = @left_margin + @pillar_x_grid*@column_width
        @pillar_x_grid += @page_config[:pillar_width][pillar_index]
        pillar_y = 150 # TODO heading heigh
        pillar_top =  @body_line_height*10
        # pillar_top = @heading_space + pillar_rect[1]

        # pillar_rect = pillar[:pillar_rect]
        article_height_sum = 0
        # parent_y = 0
        # parent_height = 0
        # parent_x   = 0
        # # pillar_top = pillar_rect[1] +
        # parent_articles_count = pillar[:article_map].select{|a| !a[:attache_type]}.length
        pillar.each do |article_path|
          h = {}
          h[:parent] = self
          h[:image_path] = article_path + "/story.pdf"
          article_info_path = article_path + "/article_info.yml"
          article_info      = YAML::load_file(article_info_path)
          article_width     = article_info[:image_width].to_f
          article_height    = article_info[:image_height].to_f
          h[:x] = pillar_x
          if article_info[:attached_type] == 'overlap'
            h[:y] = parent_y + (parent_height - article_height)
          elsif article_info[:attached_type]
            h[:y] = parent_y
            # drawing divider for attachment
            if @draw_divider
              attened_on_right_side = true
              attened_on_right_side = false if h[:x] < parent_x
              parent_order = article[:pdf_path].split("/")[1].to_i
              line_x = h[:x] - 5
              line_x = h[:x] + article_info[:image_width] + 5 unless attened_on_right_side
              line_height = article_info[:image_height]
              if article_info[:attached_type] != 'overlap'
                line_y = h[:y] +  @body_line_height*2
                line_height -=  @body_line_height*4
              end
              Line.new(parent:self, x:line_x, y:line_y, width:0, height:line_height, stroke_thickness: 0.1)
            end
          else
            h[:y] = pillar_top + article_height_sum
            parent_y = h[:y]  
            parent_x = h[:x]  
            parent_height = article_info[:image_height]
          end
          h[:width] = article_width
          h[:height]= article_height
          Image.new(h)
          unless article_info[:attached_type]
            article_height_sum += article_height 
          end
        end
      end

      # create_pillar_divider_lines if @draw_divider
      # delete_old_files
      save_pdf(output_path, :jpg=>true, :ratio => 2.0)

    end



  end



end