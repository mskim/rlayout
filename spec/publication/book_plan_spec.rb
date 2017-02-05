require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'create BookPlan' do
  before do
    @path = "/Users/mskim/demo_book_plan/book_plan.csv"
    @bp   = BookPlan.new(csv: @path)
    @cover_folder   = "/Users/mskim/demo_book_plan/front/Cover"
    @preface_folder = "/Users/mskim/demo_book_plan/front/Preface"
    @chapter_folder = "/Users/mskim/demo_book_plan/PART1_어법/01_주어와_동사의_파악"
    @sub = "/Users/mskim/demo_book_plan/PART1_어법/03_가주어와_가목적어/어법_Semi_Test_01"
  end
  
  # it 'should create BookPlan' do
  #   assert @bp.class == BookPlan
  # end
  
  it 'should create folders' do
    assert File.directory?(@cover_folder) == true
    assert File.directory?(@preface_folder) == true
    assert File.directory?(@chapter_folder) == true
    assert File.directory?(@sub) == true
  end
end

