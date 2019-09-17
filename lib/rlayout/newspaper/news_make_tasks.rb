module RLayout

  # The purpose of following classs are to process a task with a single command line call, rather than several calls
  # In an effort to increase the speed, since we can do multi-threading or other tricks to maximise cpu usage.

  class MakeIssue
    attr_reader :issue_path, :pages_path
    def initialize(path, options={})
      @issue_path = path
      unless @issue_path
        puts "Issue path not found!!!"
        return
      end

      Dir.glob("#{issue_path}/**").each do |page_path|
        MakePage.new(page_path) if page_path =~ /[0-9]$/
      end
      self
    end
  end

  class MakePage
    attr_reader :page_path, :boxes_path, :updated
    def initialize(options={})
      @page_path = options[:page_path]
      unless @page_path
        puts "Page path not found!!!"
        return
      end
      page_number     = File.basename(File.basename(@page_path))
      Dir.glob("#{page_path}/**").each do |box_path|
        result = MakeNewsBox.new(box_path)
        @updated = true if result.updated
      end
      if @updated
        puts "updating page: #{page_number}..."
      end
      self
    end
  end


  class MakeNewsBox
    attr_reader :box_path, :updated
    def initialize(path, options={})
      @box_path = path
      unless @box_path
        puts "box path not found!!!"
        return
      end

      Dir.glob("#{@box_path}/**").each do |file|
        @pdf_file = file if file =~/\.pdf$/
        @layout_file = file if file =~/\.rb$/
        @story_file = file if file =~/\.md$/
      end

      if path =~/[0-9]$/
        if need_update?(@pdf_file, @story_file, @layout_file)
          article_number  = File.basename(path)
          puts "*** updating artcle:#{article_number}"
          options= {}
          options[:article_path]  = @box_path
          options[:jpg]           = true
          puts "options[:article_path]:#{options[:article_path]}"
          RLayout::NewsBoxMaker.new(options)
          @updated = true
        end

      elsif path =~/ad$/
        if need_update?(@pdf_file, @layout_file, @story_file)
          puts "*** updating :#{File.basename(path)}"
          options= {}
          options[:article_path]  = @box_path
          options[:jpg]           = true
          RLayout::NewsBoxMaker.new(options)
          @updated = true
        end

      elsif path =~/heading$/
        if need_update?(@pdf_file, @layout_file, @story_file)
          puts "*** updating :#{File.basename(path)}"
          options= {}
          options[:article_path]  = @box_path
          options[:jpg]           = true
          RLayout::NewsBoxMaker.new(options)
          @updated = true
        end
      end
    end

    def need_update?(target, souce1, souce2)
      return true unless target
      target_updated = File.mtime(target)
      source1_updated = File.mtime(souce1)
      if souce2
        source2_updated = File.mtime(souce2)
        return target_updated < source1_updated || target_updated < source2_updated
      end
      target_updated < source1_updated
    end
  end

  class MakeArticle
    attr_reader :page_path, :boxes_path
    def initialize(options={})
      puts "in MakeArticle"
      @box_path = options[:article_path]
      unless @box_path
        puts "article path not found!!!"
        return
      end
      @page_path = File.dirname(@box_path)
      options= {}
      options[:article_path]  = @box_path
      options[:jpg]           = true
      RLayout::NewsBoxMaker.new(options)
      options = {}
      options[:section_path]  = @page_path
      options[:output_path]   = @page_path + "/section.pdf"
      options[:jpg]           = true
      puts options
      RLayout::NewsPage.section_pdf(options)
    end
  end

  class MakeSections
    attr_reader :page_path, :boxes_path
    def initialize(path, options={})
      #code
    end
  end
end
