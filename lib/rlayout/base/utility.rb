
SIZES = { "4A0" => [4767.87, 6740.79],
  "2A0" => [3370.39, 4767.87],
   "A0" => [2383.94, 3370.39],
   "A1" => [1683.78, 2383.94],
   "A2" => [1190.55, 1683.78],
   "A3" => [841.89, 1190.55],
   "A4" => [595.28, 841.89],
   "A5" => [419.53, 595.28],
   "A6" => [297.64, 419.53],
   "A7" => [209.76, 297.64],
   "A8" => [147.40, 209.76],
   "A9" => [104.88, 147.40],
  "A10" => [73.70, 104.88],
   "B0" => [2834.65, 4008.19],
   "B1" => [2004.09, 2834.65],
   "B2" => [1417.32, 2004.09],
   "B3" => [1000.63, 1417.32],
   "B4" => [708.66, 1000.63],
   "B5" => [498.90, 708.66],
   "B6" => [354.33, 498.90],
   "B7" => [249.45, 354.33],
   "B8" => [175.75, 249.45],
   "B9" => [124.72, 175.75],
  "B10" => [87.87, 124.72],
   "C0" => [2599.37, 3676.54],
   "C1" => [1836.85, 2599.37],
   "C2" => [1298.27, 1836.85],
   "C3" => [918.43, 1298.27],
   "C4" => [649.13, 918.43],
   "C5" => [459.21, 649.13],
   "C6" => [323.15, 459.21],
   "C7" => [229.61, 323.15],
   "C8" => [161.57, 229.61],
   "C9" => [113.39, 161.57],
  "C10" => [79.37, 113.39],
  "RA0" => [2437.80, 3458.27],
  "RA1" => [1729.13, 2437.80],
  "RA2" => [1218.90, 1729.13],
  "RA3" => [864.57, 1218.90],
  "RA4" => [609.45, 864.57],
 "SRA0" => [2551.18, 3628.35],
 "SRA1" => [1814.17, 2551.18],
 "SRA2" => [1275.59, 1814.17],
 "SRA3" => [907.09, 1275.59],
 "SRA4" => [637.80, 907.09],
"NRBOOK" => [637.80, 850.39],
"EXECUTIVE" => [521.86, 756.00],
"FOLIO" => [612.00, 936.00],
"LEGAL" => [612.00, 1008.00],
"LETTER" => [612.00, 792.00],
"TABLOID" => [792.00, 1224.00],
"NAMECARD"=> [260.79, 147.40],
"IDCARD"=> [147.40, 260.79],
"MARATHON"=> [841.89, 595.28],
"PRODUCT"=> [300, 300],
"80x120" => [226.772, 340.157],
"197x272" => [558.42, 771.02],
"197X272" => [558.42, 771.02],
"16절" => [558.42, 771.02],
}

module  RLayout
  module_function


  def round_rect_to_three(rect)
    new_rect = rect.dup
    new_rect.origin.x.round(3)
    new_rect.origin.y.round(3)
    new_rect.size.width.round(3)
    new_rect.size.height.round(3)
    new_rect
  end

  def nsrect2array(ns_rect)
     [ns_rect.origin.x,ns_rect.origin.y,ns_rect.size.width,ns_rect.size.height]
  end

  def nsrect2string(ns_rect)
    nsrect2array(ns_rect).to_s
  end

  def array2nsrect(array)
    NSRect.new(NSPoint.new(array[0],array[1]), NSSize.new(array[2],array[3]))
  end

  def nspoint2array(ns_point)
    [ns_point.x, ns_point.y]
  end

  def array2nspoint(array)
    NSPoint.new(array[0],array[1])
  end

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

  def union_rect(rect_1, rect_2)
    x = min_x(rect_1) < min_x(rect_2) ? min_x(rect_1) : min_x(rect_2)
    y = min_y(rect_1) < min_y(rect_2) ? min_y(rect_1) : min_y(rect_2)
    bigger_x = max_x(rect_1) > max_x(rect_2) ? max_x(rect_1) : max_x(rect_2)
    width = bigger_x - x
    bigger_y = max_y(rect_1) > max_y(rect_2) ? max_y(rect_1) : max_y(rect_2)
    height = bigger_y - y
    [x,y,width,height]
  end

  def union_rects(rects_array)
    union = rects_array.shift
    rects_array.each do |r|
      union = union_rect(union, r)
    end
    union
  end

  def union_graphic_rects(graphics_array)
    rects_array = []
    graphics_array.each do |g|
      rects_array << g.frame_rect
    end
    union_rects(rects_array)
  end

  def convert_to_pt(value)
    if value=~/cm$/
      return cm2pt(value.sub("cm","").to_f)
    elsif value=~/mm$/
      return mm2pt(value.sub("mm","").to_f)
    elsif value=~/m$/
      return meter2pt(value.sub("m","").to_f)
    elsif value=~/inch$/
      return inch2pt(value.sub("inch","").to_i)
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


  # def mm2pt(mm)
  #   mm * (72 / 25.4)
  # end

  # def cm2pt(cm)
  #   mm2pt(cm2mm(cm))
  # end

  def meter2pt(m)
    m * 2800.34646
  end

  def inch2pt(inch)
    inch2pt*72.0
  end

  def kp2pt(kp)
    kp / 1.44
  end

  def upcase_first_letter(name)
    return name if name.frozen?
    return name if name =~ /^[A-Z]/
    name[0] = name[0].upcase
    name
  end

  def parse_csv(csv_path)
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
