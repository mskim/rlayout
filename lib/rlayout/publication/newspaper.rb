
# Git Repository for each user
# when client commits change, githook triggers the layout server to pull the change.

# Rails Server with Sinatra
# Each user has working clone of Git Repository
# It pulls changes from Git Repository when notified by the webhook event
# runs update and pushed changes back to Git Repository

# Client
# installs Rubygem Newsman
# create new publication
# in config file add email and authentication key which you get from the server site
# www.newsman.com

# nesman new name --template==spring

# rake create new_issue data
# rake update pdf
# rake publish pdf_issue
# rake publish web_site

# For rake process that requires server, it
#  pushes the content to the server
#  lays out the content and downloads it pulls back the result


  #SECTION_RAKE_FILE is a single quoted heredoc to escape #{}
  SECTION_RAKE_FILE = <<-'EOF'.gsub(/^\s*/, "")
  task :default => 'section.pdf'
  source_files = FileList["**/*.md", "**/*.markdown"]

  task :pdf => source_files.ext(".pdf")
  rule ".pdf" => ".md" do |t|
    sh "/Applications/newsman.app/Contents/MacOS/newsman news_article #{t.source}"
  end
  rule ".pdf" => ".markdown" do |t|
    sh "/Applications/newsman.app/Contents/MacOS/newsman news_article ##{t.source}"
  end

  file 'section.pdf' => source_files.ext(".pdf") do |t|
    sh "/Applications/newsman.app/Contents/MacOS/newsman section #{pwd}"
  end
  EOF

#SECTION_RAKE_FILE is a single quoted heredoc to escape #{}

SAMPLE_ARTICLE_LATOUT = <<-EOF

RLayout::NewsArticleBox.new(<%= @story_options %>) do
  heading
<%= @image_text %>
#  float_image(:local_image=>"1.jpg", :grid_frame=>[0,0,1,1])
#  float_image(:local_image=>"2.jpg", :grid_frame=>[1,0,1,1])
end

EOF

SAMPLE_NEWS_ARTICLE =<<EOF
---
title: 'This is a title for Story<%= @story_index %>'
author: 'Min Soo Kim'
---

This is where sample story text goes. Fill in this area with your story. This is where sample story text goes.
Fill in this area with your story.

This is the second paragraph. You could keep on writting until it fills up the box.

The box size is determined by grid_frame value at the top. It is usually looks somethink like grid_frame: [0,0,4,6]
The first value is x, y, width, height. So this the box will have size of 4 grid wide and 6 grid tall.

EOF

DEFAULT_SECTIONS = %w{Current Economy Entertainment Sports Culture Technology }
DEFAULT_SECTIONS2 = %w{current sports culture technology}

DEFAULT_NUMBER_OF_STORIES = [5,5,5,6,6,6]
SECTION_HTML =<<EOF
<h1>Visit Preview site! click the following lind</h1>
<a href="http://www.softwarelab.me/{{publication}}/{{issue}}/{{section}}/">Visit </a>

EOF

AD_SIZE_TABLE=<<EOF
name,grid_width,grid_height
2단-통-5,5,2
2단-통-6,6,2
2단-통-7,7,2
3단-통-5,5,3
3단-통-6,6,3
3단-통-7,7,3
4단-통-5,5,4
4단-통-6,6,4
4단-통-7,7,4
5단-16-6,3,5
5단-통-5,5,5
5단-통-6,6,5
5단-통-7,7,5
5단-프릿지-6,12,5
5단-프릿지-7,14,5
6단-통-5,5,6
6단-통-6,6,6
6단-통-7,7,6
6단-프릿지-6,12,6
6단-프릿지-7,14,6
7단-15-7,3,7
7단-27-7,4,7
7단-36-7,5,7
7단-프릿지-6,12,7
7단-프릿지-7,14,7
7.5단-통-6,6,7.5
7.5단-통-7,7,7.5
7.5단-프릿지-6,12,7.5
7.5단-프릿지-7,14,7.5
8단-15-7,3,8
8단-27-7,4,8
8단-프릿지-6,12,8
8단-프릿지-7,14,8
10단-통-5,5,10
10단-통-6,6,10
10단-통-7,7,10
10단-프릿지-6,12,10
10단-프릿지-7,14,10
15단-10-7,2,15
15단-12-6,2,15
15단-15-7,3,15
15단-18-6,3,15
15단-전면-6,6,15
15단-전면-7,7,15
15단-양면-6,6,15
15단-양면-7,7,15
EOF

DEFAULT_ISSUE_PLAN =<<EOF
양면,칼라,면이름,광고크기,광고주,가사박스
1,같러,1면,5단통-6,4,삼성전자_2016_12
,,8면,5단통,3,LG전자_2016_12
2,흑백,2면,없음,5
,,7면,5단통,4,현대자동차_2016_12
3,같러,3면,5단통,4,포스코_2016_12
,,6면,5단통,4,KT_2016_12
4,흑백,4면,5단통,4,애플컴퓨터_2016_12
,,5면,전면,0,CJ_2016_12
EOF

module RLayout

  class Newspaper
    attr_accessor :name, :publication_path, :sections,
                  :grid_base, :grid_width, :grid_height,
                  :lines_in_grid, :gutter

    def initialize(options={}, &block)
      puts "init Newspaper"
      @name         = options.fetch(:name,"OurTimes")
      @name         = @name.gsub(" ","_")
      @path         = options.fetch(:path, "/Users/Shared/Newspaper")
      @publication_path = "#{@path}/#{@name}"
      @paper_size   = options.fetch(:paper_size,"A2")
      @width        = SIZES[@paper_size][0]
      @height       = SIZES[@paper_size][1]
      @sections     = options.fetch(:sections, DEFAULT_SECTIONS.dup)
      @number_of_stories = options.fetch(:number_of_stories, DEFAULT_NUMBER_OF_STORIES.dup)
      @lines_in_grid= options.fetch(:lines_in_grid, 10)
      @gutter       = options.fetch(:gutter, 10)
      @v_gutter     = options.fetch(:v_gutter, 0)
      @left_margin  = options.fetch(:left_margin, 50)
      @top_margin   = options.fetch(:top_margin, 50)
      @right_margin = options.fetch(:right_margin, 50)
      @bottom_margin= options.fetch(:bottom_margin, 50)
      @grid_base    = options.fetch(:grid_base, [7, 15])
      @grid_width   = (@width - @left_margin - @right_margin- (@grid_base[0]-1)*@gutter )/@grid_base[0]
      @grid_height  = (@height - @top_margin - @bottom_margin)/@grid_base[1]
      setup

      if block
        instance_eval(&block)
      end
      self
    end

    def setup
      puts __method__
      system "mkdir -p #{@publication_path}" unless File.exist?(@publication_path)
      save_config_file
      save_ad_plan
    end

    def save_config_file
      config_path = @publication_path + "/config.yml"
      File.open(config_path, 'w'){|f| f.write publication_info.to_yaml}
    end

    def save_ad_plan
      @default_ad_plan_path = @publication_path + "/issue_plan.csv"
      File.open(@default_ad_plan_path, 'w'){|f| f.write DEFAULT_ISSUE_PLAN}
    end

    def create_new_issue(options={})
      NewspaperIssue.new(@publication_path, options)
    end

    def publication_info
      info = {}
      info['name']        = @name
      info['sections']    = @sections
      info['number_of_stories']= @number_of_stories
      info['width']       = @width
      info['height']      = @height
      info['left_margin'] = @left_margin
      info['top_margin']  = @top_margin
      info['right_margin']= @right_margin
      info['bottom_margin']= @bottom_margin
      info['grid_base']   = @grid_base
      info['grid_width']  = @grid_width
      info['grid_height'] = @grid_height
      info['gutter']      = @gutter
      info['v_gutter']    = @v_gutter
      info['lines_in_grid']= @lines_in_grid
      info
    end

    def page_lines
      @lines_in_grid * @grid_base[1]
    end

    def line_height
      (@height - @top_margin - @bottom_margin)/page_lines
    end
  end

  class NewspaperIssue
    attr_accessor :publication_path, :issue_date,
                  :issue_number, :issue_path, :ad_plan, :ad_plan_path
    def initialize(publication_path, options={})
      puts "init of NewspaperIssue"
      @publication_path = publication_path
      puts "@publication_path:#{@publication_path}"
      @issue_date       = options.fetch(:issue_date, "2015-4-5")
      @issue_path       = @publication_path + "/" + @issue_date
      @default_ad_plan_path = @publication_path + 'ad_plan.csv'
      @ad_plan_path         = @issue_path + '/ad_plan.csv'
      system("mkdir -p #{@issue_path}")  unless File.directory?(@issue_path)
      unless File.exist?(@ad_plan_path)
        if File.exist?(@default_ad_plan_path)
          #copy ad_plan from publication template
          system("cp #{@default_ad_plan_path} #{@ad_plan_path}")
        else
          File.open(@ad_plan_path, 'w'){|f| f.write DEFAULT_AD_PLAN}
        end
      end
      if options[:create_sections]
        if File.exist?(@ad_plan_path)
          create_sections_with_ad_plan
        else
          create_sections
        end
      end
      self
    end

    def publication_name
      File.basename(@publication_path)
    end

    def profile
      grid_base = "7x15"  unless grid_base
      box_count = 4       unless box_count
      ad_type.gsub!(" ", "-")
      p = ""
      p += "#{ad_type}"
      p += "/#{grid_base}"
      p += "_H"                       if has_heading
      p += "/#{box_count}"
      p
    end

    # this is called if we have ad_plan
    # ad_plan is passed as spread pair, two facing pages 1_24, 2_23, ....
    def create_sections_with_ad_plan
      @ad_plan_csv = File.open(@ad_plan_path, 'r'){|f| f.read}
      rows  = CSV.parse(@ad_plan_csv)
      rows.shift
      rows.each_with_index do |row, i|
        spread              = row[0]
        page_array          = spread.split("_")
        first_page_number   = page_array[0]
        facing_page_number  = page_array[1]
        color = false
        color = true        if row[1] =~/[Cc]olor/
        first_ad_type       = row[2].gsub(" ", "-")
        first_advertiser    = row[3]
        first_article_count = row[4]
        if i == 0
          first_template    = @section_template_path + "#{first_ad_type}/#{first_grid_base}"
        else

        end
        # create first section
        first_page_path     = @issue_path + "/#{first_page_number}"
        system("mkdir -p #{first_page_path}")
        facing_ad_type      = row[5].gsub(" ", "-")
        facing_advertiser   = row[6]
        facing_article_count= row[7]
        facing_page_path    = @issue_path + "/#{facing_page_number}"
        system("mkdir -p #{facing_page_path}")
      end
    end

    # this is called if we have no ad_plan
    def create_sections
      publication_config = File.open(@publication_path + "/config.yml", 'r'){|f| f.read}
      @publication_info = YAML::load(publication_config)
      @publication_info['sections'].each_with_index do |section_name, i|
        section_path = @issue_path + "/#{section_name}"
        output_path = section_path + "/section.pdf"
        if i== 0
          # put newspaper heading for front page
          news_section = NewspaperSection.new(:parent=>self, :section_path=>section_path, :section_name=>section_name, :output_path=> output_path, :number_of_stories=>@publication_info['number_of_stories'][i], :has_heading=>true)
        else
          news_section = NewspaperSection.new(:parent=>self, :section_path=>section_path,  :section_name=>section_name, :output_path=> output_path, :number_of_stories=>@publication_info['number_of_stories'][i])
        end
        news_section.update_section
      end
    end

  end


  # NewspaperSection is a sinlge page of a Newspaper
  # NewspaperSection are composed of many articles.
  # NewspaperSection can have one heading or none, depending on the setion type
  # Once the layout out of the section is set,
  # each article is layouted independently by the reporter
  #  who is working on the article.
  # each article is produced as PDF and mergerd with rest of the articles.
  # If section layout changes, each reporteds will have to
  #  adjust their articles to fit new new layout.

  class NewspaperSection
    attr_accessor :issue, :section_path, :issue_numner, :date, :publication, :issue,
                  :section_name, :output_path, :has_heading, :paper_size,
                  :section_config, :articles_info, :story_frames, :grid_key,
                  :grid_width, :grid_height, :number_of_stories

    def initialize(options={}, &block)
      @issue          = options[:issue] if options[:issue]
      @section_path   = options[:section_path] if options[:section_path]
      @section_name   = options[:section_name] || "untitled"
      @output_path    = @section_path + "/section.pdf"
      @output_path    = options[:output_path]   if options[:output_path]
      @paper_size     = options.fetch(:paper_size,"A2")
      @width          = SIZES[@paper_size][0]
      @height         = SIZES[@paper_size][1]
      @width          = options['width'] if options['width']
      @height         = options['height'] if options['height']
      @lines_in_grid  = options.fetch(:lines_in_grid, 10)
      @gutter         = options.fetch(:gutter, 10)
      @v_gutter       = options.fetch(:v_gutter, 0)
      @left_margin    = options.fetch(:left_margin, 50)
      @top_margin     = options.fetch(:top_margin, 50)
      @right_margin   = options.fetch(:right_margin, 50)
      @bottom_margin  = options.fetch(:bottom_margin, 50)
      @grid_base      = options.fetch(:grid_base, [7, 12])
      @grid_base      = @grid_base.map {|e| e.to_i}
      @has_heading    = options[:has_heading] || false
      @number_of_stories = options.fetch(:number_of_stories, 5).to_i
      @grid_width     = (@width - @left_margin - @right_margin- (@grid_base[0]-1)*@gutter )/@grid_base[0]
      @grid_height    = (@height - @top_margin - @bottom_margin)/@grid_base[1]
      @grid_key       = "#{@grid_base.join("x")}"
      @grid_key      += "/H" if @has_heading
      @grid_key      += "/#{@number_of_stories}"
      @story_frames   = GRID_PATTERNS[@grid_key]
      unless @story_frames
        #TODO used some precentive default story_frames
        puts "no @story_frames for #{@grid_key}!!!"
      end

      if options['grid_key']
        @grid_key     = options['grid_key']
        @story_frames = GRID_PATTERNS[@grid_key]
        @has_heading  = grid_key.split("/")[1]=~/H/ ? true : false
      end
      system("mkdir -p #{@section_path}") unless File.exist?(@section_path)
      copy_heading_pdf if @has_heading
      section_config_path = @section_path + "/config.yml"
      @section_config = make_section_config
      File.open(section_config_path, 'w'){|f| f.write @section_config.to_yaml}
      section_rake_path = @section_path + "/Rakefile"
      File.open(section_rake_path, 'w'){|f| f.write SECTION_RAKE_FILE} unless File.exist?(section_rake_path)
      system("mkdir -p #{@section_path + "/images"}")
      @number_of_stories = @story_frames.length

      if @has_heading
        @number_of_stories -= 1
      end
      @number_of_stories.times do |i|
          create_story(i)
          make_story_layout(i)
      end
      self
    end

    def create_story(story_index)
      story_project_path =  @section_path + "/#{story_index + 1}"
      system("mkdir #{story_project_path}") unless File.directory?(story_project_path)
      story_path =  story_project_path + "/story.md"
      sample = SAMPLE_NEWS_ARTICLE.gsub("<%= @story_index %>", (story_index + 1).to_s)
      File.open(story_path, 'w'){|f| f.write sample}
      images_path = story_project_path + "/images"
      system("mkdir #{images_path}") unless File.directory?(images_path)
    end

    def make_story_layout(story_index)
      article_path  = @section_path + "/#{story_index + 1}"
      images        = Dir.glob("#{article_path}/images/*.{jpg,pdf,tiff}")
      layout_index  = story_index
      layout_index  = story_index + 1 if @has_heading
      @story_options= make_story_options(layout_index)
      @image_text   = ""
      images.each_with_index do |image, i|
        @image_text += "  float_image(:local_image=>\"#{File.basename(image)}\", :grid_frame=>[0,#{i},1,1])\n"
      end
      layout_path    = article_path + "/layout.rb"
      layout_content = SAMPLE_ARTICLE_LATOUT.gsub("<%= @story_options %>", @story_options.to_s)
      layout_content = layout_content.gsub("<%= @image_text %>", @image_text)
      # ERB doesn' seem to work in rubymotion
      # erb           = ::ERB.new(SAMPLE_ARTICLE_LATOUT)
      File.open(layout_path, 'w'){|f| f.write layout_content}
    end

    # TODO if Rubymotion YAML kit has fixed the symbol issue in YAML kit, fix it
    # Each section folder has config.yml.
    # config.yml contains information about the section.
    # At the moment, Rubymotion YAML kit doesn't seem to work with symbols it reads symbols as ':key' String.
    # So, to make it work, I am saving keys  as String instead of symbol.
    # It can play OK since I could distinguish whether the options are coming from new or open
    # for  NewspaperSection new, options keys are passed as symbols,
    # And for  NewspaperSection open, options keys are stored as String, when reading from section config file.
    # YAML kit also haves true as 1 and false as 0
    # YAML kit also reads 1. as 1.0 and 0 as 0.0, so be careful!!!! need to convert it to_i after reading.
    def make_section_config
      info ={}
      info['publication'] = @issue && @issue.publication_name || "OurTimes"
      info['issue']       = @issue && @issue.issue_number       || '100-100'
      info['date']        = @issue && @issue.issue_date         || '2015-4-5'
      info['section_name']= @section_name || "untitled"
      info['has_heading'] = @has_heading
      info['grid_key']    = @grid_key
      info['grid_size']   = [@grid_width, @grid_height]
      info['width']       = @width
      info['height']      = @height
      info['story_frames']= GRID_PATTERNS[@grid_key]
      info['left_margin']  = @left_margin
      info['right_margin'] = @right_margin
      info['top_margin']   = @top_margin
      info['bottom_margin']= @bottom_margin
      info['gutter']       = @gutter
      info
    end

    # change grid_key value in cofig.yml
    def self.change_section_layout(section_path, grid_key)
      unless GRID_PATTERNS[grid_key]
        puts "There is no grid_key as #{grid_key}"
        return
      end
      config_path = section_path + "/config.yml"
      section_config = File.open(config_path, 'r'){|f| f.read}
      section_config = YAML::load(section_config)
      section_config['grid_key'] = grid_key
      section_config['story_frames'] = story_frames = GRID_PATTERNS[grid_key.to_sym]
      File.open(config_path, 'w'){|f| f.write section_config.to_yaml}

      # grid_key has changed, so update section story files according to new layout
      # and regenerate all stroies to new layout
      # regenerate section.pdf and section.jpg
      # update new layout
      has_heading = grid_key.split("/")[0] =~/H$/ ? true : false
      story_frames = GRID_PATTERNS[@grid_key]
      number_of_stories = story_frames.length
      # update config
      section_config_path = section_path + "/config.yml"
      section_config = make_section_config
      File.open(section_config_path, 'w'){|f| f.write section_config.to_yaml}
      if has_heading
        number_of_stories -= 1
      end
      number_of_stories.times do |i|
        story_path =  section_path + "/#{i + 1}.story.md"
        if File.exist?(story_path)
          make_story_layout(i)
        else
          # Need to create more story for new pattern
          create_story(i)
          make_story_layout(i)
        end
      end
      # update section pdf
      puts "generating section pdf..."
      puts "section_path:#{section_path}"
      NewspaperSection.update_section(section_path)
    end

    # Run rake to update pdf files in section folder
    # class method
    def self.update_section(section_path)
      system ("cd #{section_path} && rake")
    end

    # Run rake to update pdf files in section folder
    def update_section
      system ("cd #{@section_path} && rake")
    end

    def make_story_options(story_index)
      story_frame_index = story_index.to_i
      options = {}
      options[:grid_frame]  = @section_config['story_frames'][story_frame_index]
      options[:grid_frame]  = eval(options[:grid_frame]) if options[:grid_frame].class == String
      options[:grid_frame]  = options[:grid_frame].map {|e| e.to_i}
      options[:gutter]      = @section_config['gutter'] || 10
      options[:v_gutter]    = @section_config['gutter'] || 0
      options[:column_count]= options[:grid_frame][2]
      options[:grid_width]  = @section_config['grid_size'][0]
      options[:grid_height] = @section_config['grid_size'][1]
      options[:width]       = options[:grid_width] * options[:grid_frame][2] + (options[:grid_frame][2] - 1)*options[:gutter]
      options[:height]      = options[:grid_height] * options[:grid_frame][3] + (options[:grid_frame][3] - 1)*options[:v_gutter]
      options
    end

    def read_story_config(section_config_path, story_index)
        config = YAML::load(File.open(section_config_path, 'r'){|f| f.read})
        # YamlKit in Rubymotion saves true as 1 and reads as 1.0
        story_frame_index = story_index.to_i
        if config['has_heading'] == true || config['has_heading'] == 1.0
          story_frame_index += 1
        end
        options = {}
        options[:grid_frame]  = config['story_frames'][story_frame_index]
        options[:grid_frame]  = eval(options[:grid_frame]) if options[:grid_frame].class == String
        options[:grid_frame]  = options[:grid_frame].map {|e| e.to_i}
        options[:grid_base]   = [options[:grid_frame][2],options[:grid_frame][3]]
        options[:gutter]      = config['gutter'] || 10
        options[:v_gutter]    = config['gutter'] || 0
        options[:column_count]= options[:grid_frame][2]
        options[:grid_width]  = config['grid_size'][0]
        options[:grid_height] = config['grid_size'][1]
        options[:x]           = 0
        options[:y]           = 0
        options[:width]       = options[:grid_width] * options[:grid_frame][2] + (options[:grid_frame][2] - 1)*options[:gutter]
        options[:height]      = options[:grid_height] * options[:grid_frame][3]+ (options[:grid_frame][3] - 1)*options[:v_gutter]
        options
    end

    def copy_heading_pdf
      @heading_sample = "/Users/Shared/SoftwareLab/news_heading/OurTimes/heading_#{@grid_key.split("x")[0]}.pdf"
      system("cp #{@heading_sample} #{@section_path}/heading.pdf") #unless File.exist?(@heading_sample)
    end

    def merge_article_pdf(options={})
      @output_path = options[:output_path] if options[:output_path]
      #TODO update page fixtures
      @articles_info.each_with_index do |info, i|
        info[:parent] = self
	      Image.new(info)
	    end

      if @output_path
        save_pdf(@output_path, options)
      else
        puts "No @output_path!!!"
      end
      self
    end

    def normalize_filenames
      new_names = []
      Dir.glob("#{@section_path}/*") do |m|
        basename = File.basename(m)
        if basename =~ /^\d+/
          r= /^\d*/
          matching_string = (basename.match r).to_s
          long_digit = make_long_ditit(matching_string, 3)
          new_base = basename.sub(matching_string, long_digit)
          new_path = @section_path + "/#{new_base}"
          puts m
          puts new_path
          # system("mv #{m} #{new_path}")
        end
      end
      new_names
    end
  end
end
