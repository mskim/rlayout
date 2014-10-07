#!/usr/local/bin/macruby
framework 'AppKit'


if  ARGV.size=0
  $stderr.puts "No source rtf file..." 
  exit 1
elsif ARGV.size = 1
  path=ARGV[0]
  destination="#{ARGV[0]}.yaml"
else 
  
end

require 'yaml'

  puts "Processing : #{path}"
  # path="/Users/mskim/Desktop/rtf_test.rtf"
  attributedString = NSAttributedString.alloc.initWithPath(path, documentAttributes:nil)
  if attributedString.nil?
    exit 1
  end
    
  divider_string="----"
  h= rtf2paradata(path, divider_string)
  File.open(destination, 'w' ) do |out|
    YAML.dump(h, out )
  end
  



TITLE=36
SUBTITLE=24
LEAD=18
AUTHOR=14

H1=28
H2=24 
H3=18

# split NSAttributedString with divider string
# returns array of NSAttributedString
def split_nsattributedstring(attributed_string, divider_string)
  att_string_array=[]
  str= attributed_string.string
  string_array=str.split(divider_string)
  position=0
  divider_length=divider_string.length
  string_array.each do |part|
    length=part.length
    range = NSMakeRange(position, length);
    att_string_array << attributed_string.attributedSubstringFromRange(range)
    position +=length + divider_length
  end
  att_string_array
end

def rtf2paradata(rtf_path, divider_string)
  magazine_hash={}
  attributedString = NSAttributedString.alloc.initWithPath(rtf_path, documentAttributes:nil)
  divisions_att_string=split_nsattributedstring(attributedString, divider_string)
  division_array=['heading', 'body','box_1','box_2']
  divisions_att_string.each_with_index do |division_att_string, index|
    para_data_array=parse_division(division_att_string, division_array[index])
    magazine_hash[division_array[index]]=para_data_array
  end
  magazine_hash
end


# parse division heading, body, or box
# convert rtf  to para_data format
def parse_division(attributedString, division_type)
  divider_string="\n"
  range = NSMakeRange(0, 0);
  paragraph_att_strings=split_nsattributedstring(attributedString, divider_string)
  
  if division_type=='heading'
      heading_hash={}
      paragraph_att_strings.each do |att_para|
        para=att_para.string
        length=para.length
        if length > 0
          a=att_para.attributesAtIndex(NSMaxRange(range), effectiveRange:range)
          f=a["NSFont"]
          pointSize=f.pointSize
          heading_hash[heading_map(pointSize)]=para
        end
      end
      return  heading_hash   
  else
      para_data_array=[]
      markdown=""
      paragraph_att_strings.each do |att_para|
        para=att_para.string
        length=para.length
        if length > 0
          a=att_para.attributesAtIndex(NSMaxRange(range), effectiveRange:range)
          f=a["NSFont"]
          pointSize=f.fontName
          pointSize=f.pointSize

          markdown+=body_map(pointSize)
          markdown+= " "
          markdown+=para
          markdown+= "\n\n "
        end
      end
      
  end
  markdown
end



def heading_map(point_size)
  return "title" if point_size >= TITLE
  return "subtitle" if point_size >= SUBTITLE
  return "lead" if point_size >= LEAD
  "author"
end

def body_map(point_size)
  return "#" if point_size >= H1
  return "##" if point_size >= H2
  return "###" if point_size >= H3
  ""
end


