CALENDAR_SYTYES = {
  type: "desktop",
  title: "Min Soo's Calendar",
  start_day: "Sunday",
  sunday_color: "red",
  heading_font: "Sunday",
  body_font: "Times",
}

# 2015 5 14
# Cover page layout
# Year Calendar
# Mini Calendar

# 2015 5 13
# Style File
# Text Align Left
# Handle Events

# 2015 5 12
# FIX IMAGE_FIT_TYPE_KEEP_RATIO
# Month and month in English
# 2014 1 2
# I should use "cal", "ncal" that does lots of stuff that I was doing.
# Use cal, instaed of re-inventing the wheel.
# 
# There are parts that make up the calendar
# 1. CalendarMonth 
#   month_title, month, month_in_english
#   days_of_the_week:  Sun Mon Tue Wed ...
#   first_row:         29  30  1   2   3
#   body_rows,          6  7   8   9   10
#   last_row           25/30 26  27  it can have dobule dates cell
# 2. Company Box 
#   Compnay Name, Logo, tel, slogun
# 3. Picture of the month
# 4. Previous, Current, and Next month as mini month
# 5. A Year calendar at the end with mini month

# Desk Top Calenar with Paired page
# 0-Cover
# 0-Cover Back
# 1-image page, 
# 1-calendar page
# 2-image page
# 2-calendar page
# last page is mini year page

# Desk Top Calenar with single page
# month_color
# mini_month
# mini_year

# Custom Events
# Nation Holidays

KOREAN_HOLYDAYS = [
  {month: 1, day: 1, name: "New Years Day" },
  {month: 3, day: 1, name: "3.1 Movement" },
  {month: 6, day: 25, name: "6 25" },
  {month: 12, day: 25, name: "Chritsmas" },
]

COMMON_YEAR_DAYS_IN_MONTH = [31, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
                            # 0 1 2 3 4 5 6 7 8 9 10 11 12
DAYS_OF_THE_WEEK  = %w[Sun Mon Tue Wed Thu Fri Sat]
MONTH_IN_ENGLISH = %w(January February March April May June July
  August September October November December)

# IMAGE_FIT_TYPE_ORIGINAL       = 0
# IMAGE_FIT_TYPE_VERTICAL       = 1
# IMAGE_FIT_TYPE_HORIZONTAL     = 2
# IMAGE_FIT_TYPE_KEEP_RATIO     = 3
# IMAGE_FIT_TYPE_IGNORE_RATIO   = 4
# IMAGE_FIT_TYPE_REPEAT_MUTIPLE = 5

module RLayout

  class Calendar < Document
    attr_accessor :template, :type, :year, :starting_month, :number_of_months, :pages, :has_cover
    attr_accessor :template_doc, :path, :events_handler, :calendar_page_template
    attr_accessor :events
    def initialize(options={})
      super
      @path             = options[:path]
      @events_path      = options.fetch(:path, default_events_path)
      @events           = CalendarEvents.new(@events_path)
      
      info_path       = @path + "/info.yml"
      if File.exists?(info_path)
        @config           = YAML::load(File.open(info_path,'r'){|f| f.read})
        @type             = @config['type']
        @year             = @config['year']
        @starting_month   = @config['month']
        @number_of_months = @config['number_of_months'] || 12
      else
        @type             = options.fetch(:type, "desk_top_calendar")
        @year             = options.fetch(:starting_year, Time.now.year)
        @starting_month   = options.fetch(:starting_month, Time.now.month)
        @number_of_months = options.fetch(:number_of_months,12)
      end
      personal_path       = @path + "/personal.yml"
      @personal_evets     = YAML::load(File.open(personal_path, 'r'){|f| f.read}) if File.exist?(personal_path)
      @ending_month       = Time.now.month + @number_of_months - 1
      create_images
      create_monthly_calendar
      create_pages
      if options[:save]
        pdf_path = path + "/Preview.pdf"
        save_pdf(pdf_path)
      end
      self
    end
                
    def save_info
      info_path     = @path + "/info.yaml"
      File.open(info_path, 'w'){|f| f.write to_hash.to_yaml}
    end
    
    def to_hash
      h={}
      h[:type]              = @type
      h[:template_path]     = @template_path
      h[:year]              = @year
      h[:starting_month]    = @starting_month
      h[:number_of_months]  = @number_of_months
      h[:year]              = @year
      h
    end
    
    def default_events_path
      "/Users/Shared/SoftwareLab/calendar/national_events.yml"
    end
    
    def default_style
      "/Users/Shared/SoftwareLab/calendar/template/calendar1.rb"
    end
    
    
    def create_images
      image_files = []
      image_files =Dir.glob("#{@path}/*.jpg")
      @month_images = []
      @number_of_months.times do |i|
        @month_images << Image.new(:image_path=>image_files[i], :image_fit_type=>IMAGE_FIT_TYPE_KEEP_RATIO, :line_width=>3, :line_color=>'black') # 3
      end
    end
        
    def create_monthly_calendar      
      @calendar_months  = []
      year              = @year.to_i
      month             = @starting_month.to_i      
      @number_of_months.times do        
        @calendar_months << CalendarMonth.new(documnet:self, year:year, month:month)
        month += 1
        if month == 13
          month = 1
          year  += 1
        end
      end
    end
    
    def create_pages      
      @pages = []
      add_cover_page
      @number_of_months.times do |i|
        add_calenard_page(i+1)
      end
    end
    
    def add_cover_page
      @pages << Page.new(self)
      # @pages << Page.new(self)
    end
    
    def add_image_page(index)
      @pages << Page.new(self)
    end
    
    def add_calenard_page(index)
      hash = {}
      hash[:year]  = @year
      hash[:month] = @starting_month.to_i + index
      hash[:events] = @events
      hash[:parent] = self
      p = CalendarPage.new(hash)
      p.add_graphic(@month_images[index]) if @month_images[index]
      p.add_graphic(@calendar_months[index]) if @calendar_months[index]
      p.relayout!
    end
    
    def add_pair_page(index)
      # add_image_page(index)
      # make deep dup
      add_calenard_page(index)
    end
    
    # genearate mini-month to use as images
    def self.save_mini_month(template, year, month, output_path)
      template_doc = Document.open(template)
      starting_date_object = Date.new(year, month, 1)
      page_template = template_doc.page_with_tag("mini_calendar_page")
      month_template = page_template.graphic_with_tag("mini_calendar")
      mini_month = CalendarMonth.new(page_template, starting_date_object, month_template, :mini_calendar=>true, :output_path=>output_path)
      mini_month.save_pdf(output_path)
    end
    #     
    def self.save_mini_month_for(template, year, starting_month, number_of_months, output_path)
    
    end
    
    def self.create_year_page
      
    end
  end
  
  class CalendarPage < Page
    attr_accessor :page, :date, :month, :calendar, :image, :organization
    attr_accessor :picture, :month_title, :prev_month, :next_month, :company, :month_container
    
    def initialize(document, options={})
      super 
      @heading        = options[:heading]
      @month_image    = options[:month_image]
      @calendar_month = options[:calendar_month]
      @company        = options[:company]
      self
    end

    def update_title
      month_in_number = @month_title.graphic_with_tag("month_in_number")
      month_in_number.set_new_text(@month.to_s) if month_in_number
      month_in_english = @month_title.graphic_with_tag("month_in_english")
      month_in_english.set_new_text(MONTH_IN_ENGLISH[@month.to_i - 1]) if month_in_english
      year = @month_title.graphic_with_tag("year")
      year.set_new_text(@year.to_s) if year
    end
    

  end
  
	class CalendarMonth < Container
    attr_accessor :year, :month, :company, :mini_month
    attr_accessor :heading_row, :rows, :document
    def initialize(options={})
      super
      @document   = options[:document]
      @year       = options[:year]
      @month      = options[:month]
      text        = `cal #{@month} #{@year}`
      @rows       = text.split("\n")
      # @days_of_the_week = @rows[1].split(" ") 
      make_rows  
      self
    end
    
    def make_rows
      make_month_name_row
      make_heading_row
      make_first_body_row
      make_body_rows
      adjust_last_row
      relayout!
    end
    
    def make_month_name_row
      row_graphic = Container.new(:parent=>self, :layout_direction=>'horizontal', :layout_space=>5, :layout_length=>1)
      CalendarCell.new(:parent=>row_graphic, :layout_length=>1)
      CalendarCell.new(:parent=>row_graphic, :text_string=> @rows.first)
      CalendarCell.new(:parent=>row_graphic, :layout_length=>1)
      @graphics << row_graphic
    end
    
    def make_heading_row
      row_graphic = Container.new(:parent=>self, :layout_direction=>'horizontal', :layout_space=>5, :layout_length=>0.7)
      DAYS_OF_THE_WEEK.each do |heading_cell_text|
        CalendarCell.new(row_graphic, :text_string=> heading_cell_text)
      end
      @graphics << row_graphic
    end
    
    def make_first_body_row
      row_graphic = Container.new(:parent=>self, :layout_direction=>'horizontal', :layout_space=>5)
      first_row_text_array = @rows[2].split(" ")
      unless first_row_text_array.length >= 7
        previous_month_last_row.split(" ").each do |prev_month_day| 
          CalendarCell.new(row_graphic, :text_string=> prev_month_day, :text_color=>'lightGray')
        end
      end
      first_row_text_array.each do |cell_text|
        CalendarCell.new(row_graphic, :text_string=> cell_text, )
      end
    end
    
    def make_body_rows
      @rows.each_with_index do |row, i|
        next if i < 3
        row_graphic = Container.new(:parent=>self, :layout_direction=>'horizontal', :layout_space=>5)
        row.split(" ").each do |cell_text|
          CalendarCell.new(row_graphic, :text_string=> cell_text)
        end
      end
    end
    
    def previous_month_last_row
      prv_month = @month.to_i - 1
      year  = @year
      if prv_month == 0
        prv_month = "12"
        year  = (@year.to_i - 1).to_s
      end
      text        = `cal #{prv_month} #{year}`
      text.split("\n").last
    end
    
    def last_row_text_array
      @rows.last.split(" ")
    end
    
    def adjust_last_row
      if has_six_rows?
        #if we have six rows(overflowing), merge overflowing cells with last row cells
        # make double numbered cell
        overflowing_row = @graphics.pop
        last_row        = @graphics.last
        double_cells    = []
        overflowing_row.graphics.each do |overflow_cell|
          last_row_cell  = last_row.graphics.shift
          dobule_cell =CalendarCell.merge_cells(last_row_cell, overflow_cell)
          dobule_cell.parent_graphic = last_row
          double_cells << dobule_cell
        end
        last_row.graphics.length
        double_cells.each do |double_cell|
          last_row.graphics.unshift(double_cell)
        end
        
      elsif last_row_text_array.length < 7
        last_row = @graphics.last
        (7 - last_row_text_array.length).times do |i|
          CalendarCell.new(last_row, :text_string=> (i + 1).to_s, :text_color=>'lightGray')
        end
      end
    end

    # is is month six row month?
    def has_six_rows?
      (@rows.length - 2) > 5
    end
	end
	
  class CalendarCell < Container
    attr_accessor :events, :month, :day
    attr_accessor :sharing_second_day, :slash_color, :slash_width
    attr_accessor :national, :personal, :luna, :current_month
    def initialize(options={})
      if options[:day]
        options[:text_string] = options[:day] 
      elsif options[:day_of_the_week]
        options[:text_string] = options[:day_of_the_week]
      end
      super
      @month        = options[:month] if options[:month]
      @events       = options[:events]
      @sharing_second_day   = nil     # for double cell
      # 
      # if @events
      #   nationals       = @events.national_event_on(@month, @day)
      #   if nationals.length > 0
      #     @national = ""
      #     nationals.each do |national_event|
      #       @national += national_event[:name] + "\n"
      #     end
      #   end
      #   personals       = @events.personal_event_on(@month, @day)
      #   
      #   if personals.length > 0
      #     @personal = ""
      #     personals.each do |personal_event|
      #       @personal += personal_event[:name] + "\n"
      #     end
      #   end
      # end
      # 
      self
    end
    
    def self.merge_cells(first, second_cell)
      dobule_cell =CalendarCell.new(nil)
      dobule_cell.add_graphic(first)
      dobule_cell.add_graphic(second_cell)
      dobule_cell
    end
    
  end

  class CalendarEvents
    attr_accessor :path, :national, :personal, :country, :universal_nationals
    def initialize(path)
      @path = path
      read_events
      self
    end
    
    def national_event_on(month, day)
      events = []
      @national.each do |hash|
        events << hash if hash[:month]== month && hash[:day] == day
      end
      events
    end
    
    def personal_event_on(month, day)
      events = []
      @personal.each do |hash|
        events << hash if hash[:month]== month.to_s && hash[:day] == day.to_s
      end
      events
    end
    
    def save_default_events(path)
      national_path = path + "/national.yml"
      File.open(national_path, 'w'){|f| f.write(@national.to_yaml)}
    end
    
    def self.national(country)
      KOREAN_HOLYDAYS
    end
    
    def self.save_national(path)
      
    end
    
    def self.save_personal(path)
      
    end
    
    # Merge two events and return merged
    def self.merge_events(first_events, second_events)
      
    end
    
    def read_personal_events(path)
      personal_path = path + "/events.txt"
      @personal = []
      
      if File.exists?(personal_path)
        data = ''
        f = File.open(personal_path, "r") 
        f.each_line do |line|
          data = line.chomp.split(",")
          hash = {
            year: data[0],
            month: data[1],
            day: data[2],
            name: data[3],
          }
          @personal << hash
        end
        # puts "@personal:#{@personal}"
      end
    
    end
    # parse event file
    def read_events
      national_path = "/Users/Shared/SoftwareLab/calendar/events" + "/national.events"
      if File.exists?(national_path)
        @national = YAML::load(File.open(@path + "/national.events", 'r'){|f| f.read})
      else
        @national = KOREAN_HOLYDAYS
      end
      read_personal_events(@path)
    end
  end
  

end
