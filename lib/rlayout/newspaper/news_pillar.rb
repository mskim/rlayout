

module RLayout

  class NewsPillar
    attr_accessor :pillar_path, :height_in_lines, :relayout

    def initialize(options={})
      @pillar_path        = options[:pillar_path]
      @height_in_lines    = options[:height_in_lines]
      @relayout           = options[:relayout]
      auto_adjust_height_all if @relayout
      self
    end

    def root_articles
      # we want to select folders like 1_1, not 1_1_1 
      folders = Dir.glob("#{@pillar_path}/*").select do|f| 
        (File.directory? f) && (f.sub(@pillar_path, "").split("/").length == 2)
      end
      folders.sort
    end

    # check if we need to regenerate_pdf
    # by updated time of story or layout.rb and PDF
    # def need_generation?(article_path)
    #   return true if @relayout
    #   story_path      = article_path + "/story.md"
    #   layout_rb_path  = article_path + "/layout.rb"
    #   story_pdf_path  = article_path + "/story.pdf"
    #   return true if File.mtime(story_path) > File.mtime(story_pdf_path)
    #   return true if File.mtime(layout_rb_path) > File.mtime(layout_rb_path)
    #   false
    # end

    def auto_adjust_height_all(options={})
      # first step is to layout articles with full_height
      root_articles.each do |article_path|
        # if need_generation?(article_path)
        h                     = {}
        h[:article_path]      = article_path
        h[:adjustable_height] = true
        NewsBoxMaker.new(h)
        # end
      end
      adjust_articles_to_fit_pillar
    end

    # read all root article height_in_lines from article_info
    def height_in_lines_array
      root_articles.map do |article_path|
        lines = read_article_height_in_lines(article_path)
      end
    end
    
    def read_article_height_in_lines(article_path)
      article_info_path = article_path + "/article_info.yml"
      h = YAML::load_file(article_info_path)
      h[:height_in_lines]
    end

    def height_in_lines_sum
      height_in_lines_array.reduce(:+)
    end

    def height_array
      root_articles.map do |article_path|
        read_article_height(article_path)
      end
    end

    def read_article_height(article_path)
      article_info_path = article_path + "/article_info.yml"
      h = YAML::load_file(article_info_path)
      h[:image_height]
    end

    def page_config_path
      File.dirname(@pillar_path) + "/config.yml"
    end

    def page_config
      page_config = YAML::load_file(page_config_path)
    end

    def body_line_height
      13.903262092238279
    end

    def actual_height_in_lines_sum
      height_array.map{|v| (v/body_line_height).round}.reduce(:+)
    end

    def height_sum
      height_array.reduce(:+)
    end

    # adjust_articles_to_fit_pillar
    # adjust heights from bottom until it fits
    def adjust_articles_to_fit_pillar
      differnce = height_in_lines_sum - @height_in_lines
      if differnce != 0
        new_heights_array    = adjusted_heights_array
        root_articles.each_with_index do |article, i|
          new_height = new_heights_array[i]
          if read_article_height_in_lines(article).round != new_height.round
            NewsBoxMaker.new(article_path: article, height_in_lines: new_height)
          end
        end
      end
    end

    # given fully expanded current_heights array, recalculate heights into desireded heights to fit in the pillar
    # by adjusting from the bottom to top, until the sum of the heights fit the total pillar height
    # while maintaining minimum height of article
    def adjusted_heights_array
      current_heights   = height_in_lines_array
      adjusted_heights  = current_heights.dup
      diffenence        = current_heights.reduce(:+) - @height_in_lines
      if diffenence > 0
        reminaing_overflow = diffenence
        current_heights.reverse.each_with_index do |article_height, i|
          if reminaing_overflow == 0 
            break
          elsif article_height > 14
            room = article_height - 14
            if room >= reminaing_overflow
              room = reminaing_overflow
              adjusted_heights[-(i+1)] = article_height - room
              break
            end
            reminaing_overflow -= room
            adjusted_heights[-(i+1)] = article_height - room
          end
        end
      elsif diffenence < 0
        underflow = diffenence
        # grow bottom article by difference
        adjusted_heights[-1] -= underflow
      end
      adjusted_heights
    end

  end
end