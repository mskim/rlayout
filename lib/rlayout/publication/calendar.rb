require File.dirname(__FILE__) + '/../rlayout_document.rb'

require 'yaml'

# 2014 1 2
# There is a unix command called "cal", "ncal" that does lots of stuff that I was doing.
# Use cal, instaed of re-inventing the wheel.
# 

# There are parts that make up the calendar
# Monthly Calendar
#   monnth_title, month, month_in_english
#   days_of_the_week, first_row, body_cells, last_row
# Company Box 
#   Compnay Name, Logo, tel, slogun
# Picture of the month
# Previou, current, and next month mini month
# A Year calendar 

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

# cwday → fixnum
# Returns the day of calendar week (1-7, Monday is 1).

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

module RLayout
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
        @national = YAML::load_file(@path + "/national.events")
      else
        @national = KOREAN_HOLYDAYS
      end
      read_personal_events(@path)
      
    end
  end
  
  class CalendarDocument < Document
    attr_accessor :template, :type, :year, :starting_month, :number_of_months, :pages, :has_cover
    attr_accessor :template_doc, :path, :events_handler, :calendar_page_template
    attr_accessor :events
    def initialize(options={})
      super
      @path             = options[:path]
      @events_path      = options.fetch(:path, default_events_path)
      @events           = CalendarEvents.new(@events_path)
      @template_path    = options.fetch(:template, default_template)
      @template         = YAML::load_file(@template_path + "/layout.yml")
      info_path       = @path + "/info.yaml"
      if File.exists?(info_path)
        @config           = YAML::load_file(info_path)
        @type             = @config[:type]
        @year             = @config[:starting_year]
        @starting_month   = @config[:starting_month]
        @number_of_months = @config[:number_of_months]
      else
        @type             = options.fetch(:type, "desk_top_calendar")
        @year             = options.fetch(:starting_year,Time.now.to_date ).year
        @starting_month   = options.fetch(:starting_month, Time.now.to_date)
        @number_of_months = options.fetch(:number_of_number_of_months,12)
      end
      @ending_month     = Time.now.to_date.next_month(@number_of_months)
      @template_doc     = Document.open(@template_path)
      @calendar_page_template    = @template_doc.pages.first
      create_pages
      # fill_in_the_pictures
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
      "/Users/Shared/SoftwareLab/calendar/events"
    end
    
    def default_template
      "/Users/Shared/SoftwareLab/calendar/template/calendar1.rlayout"
    end
    
    def fill_in_the_pictures
      image_files = []
      Dir.foreach(@path) do |file|
        if file =~/\.jpg$/ || file =~/\.JPG$/
          image_files << file
        end
      end
      @number_of_months.times do |i|
        page = @pages[i + 1]
        image_box = page.graphics.first
        full_image_path = @path + "/#{image_files[i]}"
        if File.exists?(full_image_path)
          image_box.graphics << Image.new(image_box, :image_path=>full_image_path, :image_fit_type=>1) # vetical fit
        end
        image_box.relayout!
      end
      
    end
    
    def create_image_pages
      image_files = []
      Dir.foreach(@path) do |file|
        if file =~/\.jpg$/
          image_files << file
        end
      end
      @number_of_months.times do |i|
        #crate image pages
        
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
      puts __method__
      hash = @calendar_page_template.to_hash["Page"]
      hash[:month] = index
      hash[:events] = @events
      CalendarPage.new(self, hash)
    end
    
    def add_pair_page(index)
      # add_image_page(index)
      # make deep dup
      # page = Page.new(self, @calendar_page_template.to_hash)
      
      # @pages << Page.new(self, @calendar_page_template.to_hash)
      add_calenard_page(index)
    end
    
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
    attr_accessor :calendar_month, :page, :date, :month, :calendar, :image, :organization
    attr_accessor :picture, :month_title, :prev_month, :next_month, :company, :month_container
    attr_accessor :events
    attr_accessor :year
    attr_accessor :rows, :starting_cwday, :starting_date_object, :number_of_days_in_month, :number_of_days_in_prev_month
    attr_accessor :days
    
    def initialize(document, options={})
      super 
      puts "++++++ @graphics.length:#{@graphics.length}"
      @events     = options[:events]
      @date       = @document.starting_month.next_month(options[:month])
      @year       = @document.year
      @month      = options[:month] 
      @month_title      = graphic_with_tag("title")
      @picture          = graphic_with_tag("picture")
      @month_container  = @graphics[2]
      puts  "@month_container:#{@month_container}"
      @company          = graphic_with_tag("company")
      @prev_month       = graphic_with_tag("prev_month")
      @next_month       = graphic_with_tag("next_month")
      update_title
      @starting_date_object = Date.new(@year, @month, 1)
      
      @starting_cwday     = @starting_date_object.cwday
      @number_of_days_in_month = days_in_month(@year,@month) 
      @number_of_days_in_prev_month= days_in_month(@year,@month - 1) 
      create_month_calendar_days
      update_month_container
      
      
      
      # 
      # 
      #   @starting_date_object = starting_date_object
      #   @year               = @starting_date_object.year
      #   @month              = @starting_date_object.month
      #   @month_container    = parent_graphic.month_container      
        # create_month_calendar_days
      #   update_month_container
      
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
    
    def events_for(date)
      @document.events_for(date)
      
    end
    
  

              
    def update_month_container
      @month_container.graphics.each_with_index do |row, row_index|
        next if row_index == 0  # calendar head row
        row.graphics.each_with_index do |date_container, cell_index|
          calendar_cell = cell_at(row_index-1,cell_index)
          date_field = date_container.graphic_with_tag("date")
          if date_field && calendar_cell
            if calendar_cell.current_month
              date_field.set_new_text(calendar_cell.day.to_s) 
            else
              date_field.set_new_text(calendar_cell.day.to_s)
              date_field.set_text_color(NSColor.lightGrayColor) 
            end
          end
          lunar_field = date_container.graphic_with_tag("lunar")
          lunar_field.set_new_text(calendar_cell.lunar.to_s) if lunar_field && calendar_cell
          
          national_event_field = date_container.graphic_with_tag("national")
          national_event_field.set_new_text(calendar_cell.national.to_s) if national_event_field && calendar_cell
          
          personal_event_field = date_container.graphic_with_tag("personal")
          personal_event_field.set_new_text(calendar_cell.personal.to_s) if personal_event_field && calendar_cell
                    
        end
        
      end
    end    

    def days_in_month(year, month)
      puts "year:#{year}"
      puts "month:#{month}"
       return 29 if month == 2 && Date.gregorian_leap?(year)
       COMMON_YEAR_DAYS_IN_MONTH[month]
    end
    
    def create_month_calendar_days
      puts __method__
      puts "@month:#{@month}"
      @days = []    
      if @starting_cwday == 7 # if the month starts on Sunday
        @number_of_days_in_month.times do |i|
          @days << CalendarCell.new(@month, i+1, :events=>@events)
        end
        # fill in the next month dimmed cell
        (35 - @number_of_days_in_month).times do |i|
          @days << CalendarCell.new(@month, i+1, :current_month=>false)
        end
      else
        # fill in the previous month dimmed cell
        prev_row_starting = @number_of_days_in_prev_month - @starting_cwday + 1
        @starting_cwday.times do |i|
          @days << CalendarCell.new(@month, prev_row_starting + i, :current_month=>false)
        end 
        
        # create current month cells
        @number_of_days_in_month.times do |i|
          @days << CalendarCell.new(@month, i+1, :events=>@events)
        end
        next_month_days = 35 - @number_of_days_in_month - @starting_cwday
        # fill in the next month dimmed cell
        next_month_days.times do |i|
          @days << CalendarCell.new(@month, i+1, :current_month=>false)
        end
      end
    end
    
    def cell_at(row, col)
      return if row > 4 || row < 0
      return if col > 6 || col < 0
      @days[row*7 + col]
    end
    
  end
  
  class CalendarCell
    attr_accessor :events, :month, :day, :national, :personal, :luna, :current_month
    attr_accessor :second_day, :slash_color, :slash_width
    
    def initialize(month, day, options={})
      @month        = month
      @day          = day
      @events       = options[:events]
      @second_day   = nil     # for double cell
      if @events
        nationals       = @events.national_event_on(@month, @day)
        if nationals.length > 0
          @national = ""
          nationals.each do |national_event|
            @national += national_event[:name] + "\n"
          end
        end
        personals       = @events.personal_event_on(@month, @day)
        
        if personals.length > 0
          @personal = ""
          personals.each do |personal_event|
            @personal += personal_event[:name] + "\n"
          end
        end
      end
      @current_month  = options.fetch(:current_month, true) 
      self
    end
    
    def to_hash
      
    end
    

  end
  
  class CalendarMonthGenerator
    attr_accessor :year, :month, :rows, :first_week, :last_week, :days_of_the_week

    def initialize(year, month)
      @year = year
      @month = month
      text = `cal #{@month} #{@year}`
      @rows = text.split("\n")
      @first_week = @rows[2].split(" ")
      @last_week = @rows.last.split(" ")
      @days_of_the_week = @rows[1].split(" ")
      self
    end

    def starting_day
      @first_week = @rows[2].split(" ").first
    end

    def starting_day_of_the_week
      @days_of_the_week[7 - @first_week.length] 
    end

    def last_day
      @last_week.last
    end

    def last_day_of_the_week
      @days_of_the_week[@last_week.length - 1] 
    end

    # is is month six row month?
    def six_row?
      (@rows.length - 2) > 5
    end

  end


end

# __END__
require 'minitest/autorun'

include RLayout
describe ".CaledarDocument" do
  before do
    @month = MonthCalendar.new(2013, 6)
  end
  # it 'should create .MonthCalendar' do
  #   @month.must_be_kind_of MonthCalendar
  # end
  # 
  # it 'should create 35 days' do
  #   @month.days.length.must_equal 35
  # end
  
  it 'should have prev month cells' do
    @month.days[0].current_month.must_equal false
    @month.days[1].current_month.must_equal false
    @month.days[2].current_month.must_equal false
    @month.days[3].current_month.must_equal false
    @month.days[4].current_month.must_equal false
    @month.days[5].current_month.must_equal false
  end

  it 'should respond to cell_at(row,col)' do
    @month.cell_at(0,0).must_be_kind_of CalendarCell
    @month.cell_at(0,0).current_month.must_equal false
    @month.cell_at(1,0).current_month.must_equal true
  end
end

describe ".CaledarDocument" do
  before do
    # @path = "/Users/mskim/Pictures/Photo_Booth"
    @path = "/Users/mskim/calendar"
  end
  
  it 'should create CalendarDocument' do
    @calDoc = CalendarDocument.new(:path=>@path)
    @calDoc.must_be_kind_of CalendarDocument
  end
  # 
  # it 'should have path' do
  #   @calDoc = Document.new_calendar(:path=>@path)
  #   @calDoc.path.must_equal @path
  # end
  # 
  # it 'should create 13 pages' do
  #   @calDoc = Document.new_calendar(:path=>@path)
  #   @calDoc.pages.length.must_equal 13
  # end
  # 
  # it 'should save rlayout' do
  #   @calDoc = Document.new_calendar(:path=>@path)
  #   @rlayout_path= @path + "/sample_calendar"
  #   @calDoc.rlayout(@rlayout_path)
  #   system"open #{@path}"
  #   
  # end
  
  it 'should save pdf' do
    @calDoc = CalendarDocument.new(:path=>@path)
    @pdf_path="/Users/mskim/Development/MacRuby/rlayout/working/test/pdf/calendar.pdf"
    @rlayout_path="/Users/mskim/Development/MacRuby/rlayout/working/test/pdf/calendar.rlayout"
    @calDoc.rlayout(@rlayout_path)
    system"open #{@rlayout_path}"
  end
end

# describe ".CaledarPage" do
#   before do
#     @calDoc       = Document.new_calendar
#     @calendar_page_template   = @calDoc.pages.first
#     @first_date   = @calendar_page_template.date 
#     @second_page  = @calDoc.pages[1]
#     @second_date  = @second_page.date 
#     @last_date    = @calDoc.pages.last.date
#     
#   end
#   
#   it 'should create CalendarPage' do
#     @calendar_page_template.must_be_kind_of CalendarPage
#   end
# 
#   it 'should create date object' do
#     @first_date.must_be_kind_of Date
#   end
#   
#   it 'should create first date object' do
#     @first_date.mon.must_equal 5
#   end
#   
#   it 'should create second date object' do
#     @second_date.mon.must_equal 6
#   end
#   
#   it 'should create last date object' do
#     @last_date.mon.must_equal 4
#   end
# end
# 
# describe '.Calendar' do
#   
#   
#   
#   
# end
describe ".CalendarEvents" do
  before do
    @path = "/Users/mskim/Pictures/Photo_Booth"
    @events = CalendarEvents.new(@path)
  end
  
  it 'should create .CalendarEvents' do
    @events.must_be_kind_of CalendarEvents
  end
  
  it 'should save default events' do
    @path = "/Users/Shared/SoftwareLab/calendar/events"
    national_path = @path + "/national.yml"
    @events.save_default_events(@path)
    assert(File.exists?(national_path))
  end
  
  it 'should return evets 1,1' do
    e = @events.national_event_on(1,1)
    e.first[:name].must_equal "New Years Day"
  end
  
  it 'should return events 6,25' do
    e = @events.national_event_on(6,25)
    e.first[:name].must_equal "6 25"
  end
  
  # it 'should return personal event 1,29' do
  #   e = @events.personal_event_on(1,29)
  #   e.first[:name].must_equal "MinSoo's Birthday"
  # end
end
