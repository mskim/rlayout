#
# module RLayout
#
# class Parser
#   attr_reader :tags
#
#   def initialize(str)
#     @buffer = StringScanner.new(str)
#     @tags   = []
#     parse
#   end
#
#   def parse
#     until @buffer.eos?
#       skip_spaces
#       parse_element
#     end
#   end
#
#   def parse_element
#     if @buffer.peek(1) == '<'
#       @tags << find_tag
#       last_tag.content = find_content
#     end
#   end
#
#   def skip_spaces
#     @buffer.skip(/\s+/)
#   end
#
#   def find_tag
#     @buffer.getch
#     tag = @buffer.scan(/\w+/)
#     @buffer.getch
#     Tag.new(tag)
#   end
#
#   def find_content
#     tag = last_tag.name
#     content = @buffer.scan_until /<\/#{tag}>/
#     content.sub("</#{tag}>", "")
#   end
#
#   def first_tag
#     @tags.first
#   end
#
#   def last_tag
#     @tags.last
#   end
# end
#
# class Tag
#   attr_reader :name
#   attr_accessor :content
#
#   def initialize(name)
#     @name = name
#   end
# end
#
# end

__END__
require 'minitest/autorun'
describe "StringScanner" do
  let (:buff) { StringScanner.new "testing" }

  it "can peek one step ahead" do
    assert_equal(buff.peek 1, "t")
  end

  it "can read one char and return it" do
    assert_equal(buff.getch, "t")
    assert_equal(buff.getch, "e")
  end
end
