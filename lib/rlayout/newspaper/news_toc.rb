module RLayout

  class NewsToc 
    attr_reader :article_path, :output_path
    attr_reader :title, :csv_data

    def initialize(options={})
      @article_path = options[:article_path]
      @output_path  = @article_path + "/story.pdf"
      @story_path   = @article_path + "/story.md"
      layout_rb_path= @article_path + "/layout.rb"
      @layout_rb    = File.open(layout_rb_path, 'r'){|f| f.read}
      if @layout_rb
        @news_box   = eval(@layout_rb)
      else
        puts "layout.rb file not found!!!"
        return 
      end
      if @news_box.is_a?(SyntaxError)
        puts "SyntaxError in layout.rb file !!!!"
        return
      end
      read_table_content
      add_heading_to_content
      add_leader_table_to_content
      rlayout!

      if @news_box
        delete_old_files
        @news_box.save_pdf_with_ruby(@output_path, :jpg=>true, :ratio => 2.0)
        if @time_stamp
          stamped_path      = @output_path.sub(/\.pdf$/, "#{@time_stamp}.pdf")
          output_jpg_path   = @output_path.sub(/pdf$/, "jpg")
          stamped_jpg_path  = stamped_path.sub(/pdf$/, "jpg")
          system("cp #{@output_path} #{stamped_path}")
          system("cp #{output_jpg_path} #{stamped_jpg_path}")
        end
      end
      self
    end

    def read_table_content
      source = File.open(@story_path, 'r'){|f| f.read}
      begin
        if (md = source.match(/^(---\s*\n.*?\n?)^(---\s*$\n?)/m))
          @contents = md.post_match
          @metadata = YAML.load(md.to_s)
        else
          @contents = source
        end
      rescue => e
        puts "YAML Exception reading #filename: #{e.message}"
      end
      @heading                = @metadata
      @title        = @heading[:title]
      @csv_data     = @contents
    end

    def add_heading_to_content
      options = {}
      options[:x] = @news_box.left_margin
      options[:y] = @news_box.top_margin
      options[:width] = @news_box.width - @news_box.left_margin - @news_box.right_margin
      @heading  = RLayout::RHeading.new(options)
      @news_box.add_graphic(@heading)
    end

    def add_leader_table_to_content
      options         = {}
      options[:x]     = @news_box.left_margin
      options[:y]     = @news_box.top_margin
      options[:width] = @news_box.width - @news_box.left_margin - @news_box.right_margin
      options[:title] = @title
      csv = CSV.parse(@csv_data)
      options[:table_data] = csv.to_a.map do |row|
        row.to_a
      end
      @toc_table = RLayout::RLeaderTable.new(options)
      @news_box.add_graphic(@toc_table)
    end

    def delete_old_files
      old_pdf_files = Dir.glob("#{@article_path}/story*.pdf")
      old_jpg_files = Dir.glob("#{@article_path}/story*.jpg")
      old_pdf_files += old_jpg_files
      old_pdf_files.each do |old|
        system("rm #{old}")
      end
    end

  end




end