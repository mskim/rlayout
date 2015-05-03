require File.dirname(__FILE__) + "/../spec_helper"

describe ".Calendar" do
  before do
    # @path = "/Users/mskim/Pictures/Photo_Booth"
    @path = "/Users/mskim/calendar/calendar1.rlayout/layout.yml"
    @rlayout_path="/Users/mskim/Development/MacRuby/rlayout/working/test/pdf/calendar.rlayout/layout.yml"
    
  end
  
  # it 'should create Calendar' do
  #   @calDoc = Calendar.new(:path=>@path)
  #   @calDoc.must_be_kind_of Calendar
  # end
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

__END__
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
