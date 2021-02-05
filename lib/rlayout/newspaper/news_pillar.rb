# TODO
# save pillar_config.yml
# pillar_width
# pillar_height
# pillar_height_in_lines
# root_articles_count


module RLayout

  class NewsPillar
    attr_accessor :pillar_path, :pillar_config, :height_in_lines

    def initialize(options={})
      @pillar_path        = options[:pillar_path]
      @pillar_config_path = @pillar_path + "/pillar_config.yml"
      unless File.exist?(@pillar_config_path)
        puts "no pillar_config.yml found!!!:#{@pillar_config_path}"
        return
      end
      read_pillar_config
      @height_in_lines    = @pillar_config[:height_in_lines]
      auto_adjust_height_all
      self
    end

    def pillar_config_path
      @pillar_path + "/pillar_config.yml"
    end

    def read_pillar_config 
      @pillar_config = YAML::load_file(pillar_config_path)
    end

    def root_articles
      # we want to select folders like 1_1, not 1_1_1 
      Dir.glob("#{@pillar_path}/*").select do|f| 
        (File.directory? f) && (f.sub(@pillar_path, "").split("/").length == 2)
      end
    end

    # check if we need to regenerate_pdf
    # by updated time of story or layout.rb and PDF
    def need_generation?(article_path)
      story_path      = article_path + "/story.md"
      layout_rb_path  = article_path + "/layout.rb"
      story_pdf_path  = article_path + "/story.pdf"
      return true if File.mtime(story_path) > File.mtime(story_pdf_path)
      return true if File.mtime(layout_rb_path) > File.mtime(layout_rb_path)
      false
    end

    def auto_adjust_height_all(options={})
      # first step is to layout articles with full_height
      root_articles.each do |article_path|
        if need_generation?(article_path)
          h                     = {}
          puts article_path
          h[:article_path]      = article_path
          h[:adjustable_height] = true
          puts article_path
          NewsBoxMaker.new(h)
        end
      end
      adjust_articles_to_fit_pillar
    end

    # read all root article height_in_lines from article_info
    def height_in_lines_array
      root_articles.map do |article_path|
        read_article_height_in_lines(article_path)
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

    # adjust_articles_to_fit_pillar
    # adjust heights from bottom until it fits
    def adjust_articles_to_fit_pillar
      differnce = height_in_lines_sum - @height_in_lines
      if differnce != 0
        # get adjusted_heights_array to fit
        new_heights_array    = adjusted_heights_array
        # puts new_heights_array.reduce(:+)
        root_articles.each_with_index do |article, i|
          new_height = new_heights_array[i]
          if read_article_height_in_lines(article).round != new_height.round
            puts "current:#{read_article_height_in_lines(article)} new:#{new_height} "
            NewsBoxMaker.new(article_path: article, fixed_height_in_lines: new_height)
          end
        end
      end
    end

    # given fully expanded current_heights array, recalculate heights into desireded heights to fit in the pillar
    # by adjusting from the bottom to top, until the sum of the heights fit the total pillar height
    # while maintaining minimum height of article
    def adjusted_heights_array
      current_heights   = height_in_lines_array
      adjusted_heights  = height_in_lines_array.dup
      diffenence        = height_in_lines_array.reduce(:+) - @height_in_lines
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
      else
        underflow = diffenence
        # grow bottom article by difference
        adjusted_heights[-1] += underflow
      end
      adjusted_heights
    end

  end
end