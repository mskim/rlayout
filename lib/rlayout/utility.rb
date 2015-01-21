
module  Utility
    
  def min_x(rect)
    rect[0]
  end

  def min_y(rect)
    rect[1]
  end

  def mid_x(rect)
    rect[0] + rect[2]/2
  end

  def mid_y(rect)
    rect[1] + rect[3]/2
  end

  def max_x(rect)
    rect[0] + rect[2]
  end

  def max_y(rect)
    rect[1] + rect[3]
  end

  def contains_rect(rect_1,rect_2)
    (rect_1[0]<=rect_2[0] && max_x(rect_1) >= max_x(rect_2)) && (rect_1[1]<=rect_2[1] && max_y(rect_1) >= max_y(rect_2))
  end

  def intersects_x(rect1, rect2)
    (max_x(rect1) > rect2[0] && max_x(rect2) > rect1[0]) || (max_x(rect2) > rect1[0] && max_x(rect1) > rect2[0])
  end

  def intersects_y(rect1, rect2)
    (max_y(rect1) > rect2[1] && max_y(rect2) > rect1[1]) || (max_y(rect2) > rect1[1] && max_y(rect1) > rect2[1])
  end

  def intersects_rect(rect_1, rect_2)
    intersects_x(rect_1, rect_2) && intersects_y(rect_1, rect_2)
  end

  def convert_to_pt(value)
    if value=~/cm$/
      return cm2pt(value.sub("cm","").to_i)
    elsif value=~/mm$/
      return mm2pt(value.sub("mm","").to_i)
    # elsif value=~/inch$/
    end
    value
  end
  
  def pt2mm(pt)
    pt * 0.352778
  end
  
  def pt2cm(pt)
    pt * 0.0352778
  end
  
  def pt2kp(pt)	
    pt * 1.44    
  end
  
  def mm2pt(mm)
    mm * 2.834646
  end
  
  def cm2pt(cm)
    cm * 28.34646
  end
  
  def kp2pt(kp)
    kp / 1.44
  end   

  def parse_csv(csv_path)
    puts "csv_path:#{csv_path}"
    require 'csv'
    unless File.exists?(csv_path)
      puts "#{csv_path} doesn't exist ..."
      return nil
    end
    rows=[]
    CSV.foreach(csv_path) do |line|
      rows << line
    end
    rows
  end
  
  def in_groups_of(array, pieces)
    return array if pieces < 2 
    chunks = []
    while array.length > 0
      chunks << array.shift(pieces)
    end
    chunks
  end
  
  # just chop the array into pieces, no tapering
  def divide_array_into_uneven_chunks_of(array, pieces)
    return array if pieces < 2 
    chunks = []
    while array.length > 0
      chunks << array.shift(pieces)
    end
    chunks
  end
  
  # divide given array into pieces, tapers the last chunks into even numbers 
  def divide_array_into(array, pieces)
    len = array.length    
    mid = (len/pieces)
    chunks = []
    start = 0
    1.upto(pieces) do |i|
      last = start+mid
      last = last-1 unless len%pieces >= i
      chunks << array[start..last] || []
      start = last+1
    end
    chunks    
  end

  # it divide an array into chunks of smaller arrays of evenly distrubuted length, the last few arrays might be smaller if it has remainders 
  def chunk_array(array, chunk_length=2)
    pieces=array.length/chunk_length
    if array.length%chunk_length > 0
      pieces +=1
    end
    len = array.length
    mid = (len/pieces)
    chunks = []
    start = 0
    1.upto(pieces) do |i|
      last = start+mid
      last = last-1 unless len%pieces >= i
      chunks << array[start..last] || []
      start = last+1
    end
    chunks
  end

  # make 1 into 001
  # s= "1", digits = 3
  def make_long_ditit(s, digits)
    s.rjust(digits,"0")
  end

  ############ git related

  # return new or modified file in git repo
  def get_git_modified(path)
    files = `cd #{path} && git status`
    files.split("\n").select do |a|
      if a =~/new file:/ || a =~/modified:/
        true
      end
    end
  end

  STARTING      = "2013-4-20"
  EXPIRATION    = "2013-01-11"
  NETWORK       = "7c:6d:62:8c:dd:aa"
  APP           = "NameCard"
  NAME          = "Min Soo Kim"

  class AboutRLayout
    attr_accessor :name, :app_type, :starting, :expiration
    def initialize
      @name       = NAME
      @app_type   = APP
      @starting   = STARTING
      @expiration = EXPIRATION
      self
    end
    
    def next_step?
      NETWORK
    end
        
    def what_time?
      @expiration
    end
  end
end


