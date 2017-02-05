require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'Calendar' do
  before do
    @path = "/Users/mskim/calendar/demo1"
    @svg_path = "/Users/mskim/calendar/demo1/demo1.svg"
    @cal  = Calendar.new(path:@path)
  end
  it 'should create Calenar' do
    assert @cal.class == Calendar
  end
  it 'should have pages' do
    assert @cal.pages.length == 14
  end
  it 'should save cal' do
    assert @cal.save_svg(@svg_path)
    assert File.exist?(@svg_path)
    system "open #{@svg_path}"
  end
  
end

__END__
describe 'CalendarCell' do
  before do
    @calCell  = CalendarCell.new(:month=>'5', :day => '14')
    @svg_path = File.dirname(__FILE__) + "/../output/calendar_cell_test.svg"
  end
  it 'should create CalendarCell' do
    assert @calCell.class == CalendarCell
  end
  it 'CalendarCell should have day' do
    assert @calCell.day == '14'
    assert @calCell.month == '5'
  end
  
  it 'should save svg' do
     @calCell.save_svg(@svg_path)
     system("open #{@svg_path}")
   end
end

describe "CalendarMonth" do
  before do
    @month = CalendarMonth.new(width: 400, height: 400, year: '2015', month: "5")
    @svg_path = File.dirname(__FILE__) + "/../output/calendar_month_test.svg"
  end
  
  it 'should create month' do
    assert @month.class == CalendarMonth
    assert @month.year == "2015"
    assert @month.month == "5"
    assert @month.first_week.class == Array
    assert @month.first_week.length == 2
    assert @month.fifth_week.length == 7
    assert @month.last_day == "31"
    assert @month.has_six_rows?
  end
  
  it 'should save svg' do
     @month.save_svg(@svg_path)
     system("open #{@svg_path}")
   end
end

__END__

describe ".Calendar" do
  before do
    # @path = "/Users/mskim/Pictures/Photo_Booth"
    @path = "/Users/mskim/calendar/calendar1.rlayout/layout.yml"
    @rlayout_path="/Users/mskim/Development/MacRuby/rlayout/working/test/pdf/calendar.rlayout/layout.yml"
    @calDoc = Calendar.new(:path=>@rlayout_path)
  end
  
  it 'should create Calendar' do
     @calDoc.must_be_kind_of Calendar
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
  
  # it 'should save pdf' do
  #   @calDoc = Calendar.new(:path=>@path)
  #   @pdf_path="/Users/mskim/Development/MacRuby/rlayout/working/test/pdf/calendar.pdf"
  #   @rlayout_path="/Users/mskim/Development/MacRuby/rlayout/working/test/pdf/calendar.rlayout"
  #   h = @calDoc.open(@rlayout_path)
  #   # system"open #{@rlayout_path}"
  # end
end

describe ".CaledarPage" do
  before do
    @calDoc       = Document.new_calendar
    @calendar_page_template   = @calDoc.pages.first
    @first_date   = @calendar_page_template.date 
    @second_page  = @calDoc.pages[1]
    @second_date  = @second_page.date 
    @last_date    = @calDoc.pages.last.date
    
  end
  
  it 'should create CalendarPage' do
    @calendar_page_template.must_be_kind_of CalendarPage
  end

  it 'should create date object' do
    @first_date.must_be_kind_of Date
  end
  
  it 'should create first date object' do
    @first_date.mon.must_equal 5
  end
  
  it 'should create second date object' do
    @second_date.mon.must_equal 6
  end
  
  it 'should create last date object' do
    @last_date.mon.must_equal 4
  end
end



__END__

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
