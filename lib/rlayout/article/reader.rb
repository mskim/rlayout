# encoding: UTF-8
# Public: Methods for retrieving lines from AsciiDoc source files
# This is from Asciidoctor::Reader

EOL = "\n"
module RLayout
class Reader
  class Cursor
    attr_accessor :file
    attr_accessor :dir
    attr_accessor :path
    attr_accessor :lineno

    def initialize file, dir = nil, path = nil, lineno = nil
      @file = file
      @dir = dir
      @path = path
      @lineno = lineno
    end

    def line_info
      %(#{path}: line #{lineno})
    end

    alias :to_s :line_info
  end

  attr_reader :file
  attr_reader :dir
  attr_reader :path

  # Public: Get the 1-based offset of the current line.
  attr_reader :lineno

  # Public: Get the document source as a String Array of lines.
  attr_reader :source_lines

  # Public: Control whether lines are processed using Reader#process_line on first visit (default: true)
  attr_accessor :process_lines

  # Public: Initialize the Reader object
  def initialize data = nil, cursor = nil, opts = {:normalize => false}
    if !cursor
      @file = @dir = nil
      @path = '<stdin>'
      @lineno = 1 # IMPORTANT lineno assignment must proceed prepare_lines call!
    elsif cursor.is_a? ::String
      @file = cursor
      @dir, @path = ::File.split @file
      @lineno = 1 # IMPORTANT lineno assignment must proceed prepare_lines call!
    else
      @file = cursor.file
      @dir = cursor.dir
      @path = cursor.path || '<stdin>'
      if @file
        unless @dir
          # REVIEW might to look at this assignment closer
          @dir = ::File.dirname @file
          @dir = nil if @dir == '.' # right?
        end

        unless cursor.path
          @path = ::File.basename @file
        end
      end
      @lineno = cursor.lineno || 1 # IMPORTANT lineno assignment must proceed prepare_lines call!
    end
    @lines = data ? (prepare_lines data, opts) : []
    @source_lines = @lines.dup
    @eof = @lines.empty?
    @look_ahead = 0
    @process_lines = true
    @unescape_next_line = false
  end

  # by Min Soo Kim
  # 2015 5 6
  # return text_blocks_array
  def text_blocks
    blocks_array = []
    block = []
    @lines.each do |line|
      # filter out carriage return key, if line has one.
      filtered_line = line.gsub(/$\r/, "")
      if filtered_line== ""
        if block.length > 0
           blocks_array << block
           block = []
        end
      else
        block << filtered_line
      end
    end
    if block.length > 0
      blocks_array << block
    end
    blocks_array
  end
  
  # Internal: Prepare the lines from the provided data
  #
  # This method strips whitespace from the end of every line of
  # the source data and appends a LF (i.e., Unix endline). This
  # whitespace substitution is very important to how Asciidoctor
  # works.
  #
  # Any leading or trailing blank lines are also removed.
  #
  # data - A String Array of input data to be normalized
  # opts - A Hash of options to control what cleansing is done
  #
  # Returns The String lines extracted from the data
  def prepare_lines data, opts = {}
    if data.is_a? ::String
      if opts[:normalize]
        Helpers.normalize_lines_from_string data
      else
        data.split EOL
      end
    else
      if opts[:normalize]
        Helpers.normalize_lines_array data
      else
        data.dup
      end
    end
  end

  # Internal: Processes a previously unvisited line
  #
  # By default, this method marks the line as processed
  # by incrementing the look_ahead counter and returns
  # the line unmodified.
  #
  # Returns The String line the Reader should make available to the next
  # invocation of Reader#read_line or nil if the Reader should drop the line,
  # advance to the next line and process it.
  def process_line line
    @look_ahead += 1 if @process_lines
    line
  end

  # Public: Check whether there are any lines left to read.
  #
  # If a previous call to this method resulted in a value of false,
  # immediately returned the cached value. Otherwise, delegate to
  # peek_line to determine if there is a next line available.
  #
  # Returns True if there are more lines, False if there are not.
  def has_more_lines?
    !(@eof || (@eof = peek_line.nil?))
  end

  # Public: Peek at the next line and check if it's empty (i.e., whitespace only)
  #
  # This method Does not consume the line from the stack.
  #
  # Returns True if the there are no more lines or if the next line is empty
  def next_line_empty?
    peek_line.nil_or_empty?
  end

  # Public: Peek at the next line of source data. Processes the line, if not
  # already marked as processed, but does not consume it.
  #
  # This method will probe the reader for more lines. If there is a next line
  # that has not previously been visited, the line is passed to the
  # Reader#process_line method to be initialized. This call gives
  # sub-classess the opportunity to do preprocessing. If the return value of
  # the Reader#process_line is nil, the data is assumed to be changed and
  # Reader#peek_line is invoked again to perform further processing.
  #
  # direct  - A Boolean flag to bypasses the check for more lines and immediately
  #           returns the first element of the internal @lines Array. (default: false)
  #
  # Returns the next line of the source data as a String if there are lines remaining.
  # Returns nil if there is no more data.
  def peek_line direct = false
    if direct || @look_ahead > 0
      @unescape_next_line ? @lines[0][1..-1] : @lines[0]
    elsif @eof || @lines.empty?
      @eof = true
      @look_ahead = 0
      nil
    else
      # FIXME the problem with this approach is that we aren't
      # retaining the modified line (hence the @unescape_next_line tweak)
      # perhaps we need a stack of proxy lines
      if !(line = process_line @lines[0])
        peek_line
      else
        line
      end
    end
  end

  # Public: Peek at the next multiple lines of source data. Processes the lines, if not
  # already marked as processed, but does not consume them.
  #
  # This method delegates to Reader#read_line to process and collect the line, then
  # restores the lines to the stack before returning them. This allows the lines to
  # be processed and marked as such so that subsequent reads will not need to process
  # the lines again.
  #
  # num    - The Integer number of lines to peek.
  # direct - A Boolean indicating whether processing should be disabled when reading lines
  #
  # Returns A String Array of the next multiple lines of source data, or an empty Array
  # if there are no more lines in this Reader.
  def peek_lines num = 1, direct = true
    old_look_ahead = @look_ahead
    result = []
    num.times do
      if (line = read_line direct)
        result << line
      else
        break
      end
    end

    unless result.empty?
      result.reverse_each {|line| unshift line }
      @look_ahead = old_look_ahead if direct
    end

    result
  end

  # Public: Get the next line of source data. Consumes the line returned.
  #
  # direct  - A Boolean flag to bypasses the check for more lines and immediately
  #           returns the first element of the internal @lines Array. (default: false)
  #
  # Returns the String of the next line of the source data if data is present.
  # Returns nil if there is no more data.
  def read_line direct = false
    if direct || @look_ahead > 0 || has_more_lines?
      shift
    else
      nil
    end
  end

  # Public: Get the remaining lines of source data.
  #
  # This method calls Reader#read_line repeatedly until all lines are consumed
  # and returns the lines as a String Array. This method differs from
  # Reader#lines in that it processes each line in turn, hence triggering
  # any preprocessors implemented in sub-classes.
  #
  # Returns the lines read as a String Array
  def read_lines
    lines = []
    while has_more_lines?
      lines << shift
    end
    lines
  end
  alias :readlines :read_lines

  # Public: Get the remaining lines of source data joined as a String.
  #
  # Delegates to Reader#read_lines, then joins the result.
  #
  # Returns the lines read joined as a String
  def read
    read_lines * EOL
  end

  # Public: Advance to the next line by discarding the line at the front of the stack
  #
  # direct  - A Boolean flag to bypasses the check for more lines and immediately
  #           returns the first element of the internal @lines Array. (default: true)
  #
  # returns a Boolean indicating whether there was a line to discard.
  def advance direct = true
    !!read_line(direct)
  end

  # Public: Push the String line onto the beginning of the Array of source data.
  #
  # Since this line was (assumed to be) previously retrieved through the
  # reader, it is marked as seen.
  #
  # returns nil
  def unshift_line line_to_restore
    unshift line_to_restore
    nil
  end
  alias :restore_line :unshift_line

  # Public: Push an Array of lines onto the front of the Array of source data.
  #
  # Since these lines were (assumed to be) previously retrieved through the
  # reader, they are marked as seen.
  #
  # Returns nil
  def unshift_lines lines_to_restore
    # QUESTION is it faster to use unshift(*lines_to_restore)?
    lines_to_restore.reverse_each {|line| unshift line }
    nil
  end
  alias :restore_lines :unshift_lines

  # Public: Replace the current line with the specified line.
  #
  # Calls Reader#advance to consume the current line, then calls
  # Reader#unshift to push the replacement onto the top of the
  # line stack.
  #
  # replacement  - The String line to put in place of the line at the cursor.
  #
  # Returns nothing.
  def replace_line replacement
    advance
    unshift replacement
    nil
  end

  # Public: Strip off leading blank lines in the Array of lines.
  #
  # Examples
  #
  #   @lines
  #   => ["", "", "Foo", "Bar", ""]
  #
  #   skip_blank_lines
  #   => 2
  #
  #   @lines
  #   => ["Foo", "Bar", ""]
  #
  # Returns an Integer of the number of lines skipped
  def skip_blank_lines
    return 0 if eof?

    num_skipped = 0
    # optimized code for shortest execution path
    while (next_line = peek_line)
      if next_line.empty?
        advance
        num_skipped += 1
      else
        return num_skipped
      end
    end

    num_skipped
  end

  # Public: Skip consecutive lines containing line comments and return them.
  #
  # Examples
  #   @lines
  #   => ["// foo", "bar"]
  #
  #   comment_lines = skip_comment_lines
  #   => ["// foo"]
  #
  #   @lines
  #   => ["bar"]
  #
  # Returns the Array of lines that were skipped
  def skip_comment_lines opts = {}
    return [] if eof?

    comment_lines = []
    include_blank_lines = opts[:include_blank_lines]
    while (next_line = peek_line)
      if include_blank_lines && next_line.empty?
        comment_lines << shift
      elsif (commentish = next_line.start_with?('//')) && (match = CommentBlockRx.match(next_line))
        comment_lines << shift
        comment_lines.push(*(read_lines_until(:terminator => match[0], :read_last_line => true, :skip_processing => true)))
      elsif commentish && CommentLineRx =~ next_line
        comment_lines << shift
      else
        break
      end
    end

    comment_lines
  end

  # Public: Skip consecutive lines that are line comments and return them.
  def skip_line_comments
    return [] if eof?

    comment_lines = []
    # optimized code for shortest execution path
    while (next_line = peek_line)
      if CommentLineRx =~ next_line
        comment_lines << shift
      else
        break
      end
    end

    comment_lines
  end

  # Public: Advance to the end of the reader, consuming all remaining lines
  #
  # Returns nothing.
  def terminate
    @lineno += @lines.size
    @lines.clear
    @eof = true
    @look_ahead = 0
    nil
  end

  # Public: Check whether this reader is empty (contains no lines)
  #
  # Returns true if there are no more lines to peek, otherwise false.
  def eof?
    !has_more_lines?
  end
  alias :empty? :eof?

  # Public: Return all the lines from `@lines` until we (1) run out them,
  #   (2) find a blank line with :break_on_blank_lines => true, or (3) find
  #   a line for which the given block evals to true.
  #
  # options - an optional Hash of processing options:
  #           * :break_on_blank_lines may be used to specify to break on
  #               blank lines
  #           * :skip_first_line may be used to tell the reader to advance
  #               beyond the first line before beginning the scan
  #           * :preserve_last_line may be used to specify that the String
  #               causing the method to stop processing lines should be
  #               pushed back onto the `lines` Array.
  #           * :read_last_line may be used to specify that the String
  #               causing the method to stop processing lines should be
  #               included in the lines being returned
  #
  # Returns the Array of lines forming the next segment.
  #
  # Examples
  #
  #   data = [
  #     "First line\n",
  #     "Second line\n",
  #     "\n",
  #     "Third line\n",
  #   ]
  #   reader = Reader.new data, nil, :normalize => true
  #
  #   reader.read_lines_until
  #   => ["First line", "Second line"]
  def read_lines_until options = {}
    result = []
    advance if options[:skip_first_line]
    if @process_lines && options[:skip_processing]
      @process_lines = false
      restore_process_lines = true
    else
      restore_process_lines = false
    end

    if (terminator = options[:terminator])
      break_on_blank_lines = false
      break_on_list_continuation = false
    else
      break_on_blank_lines = options[:break_on_blank_lines]
      break_on_list_continuation = options[:break_on_list_continuation]
    end
    skip_line_comments = options[:skip_line_comments]
    line_read = false
    line_restored = false

    complete = false
    while !complete && (line = read_line)
      complete = while true
        break true if terminator && line == terminator
        # QUESTION: can we get away with line.empty? here?
        break true if break_on_blank_lines && line.empty?
        if break_on_list_continuation && line_read && line == LIST_CONTINUATION
          options[:preserve_last_line] = true
          break true
        end
        break true if block_given? && (yield line)
        break false
      end

      if complete
        if options[:read_last_line]
          result << line
          line_read = true
        end
        if options[:preserve_last_line]
          restore_line line
          line_restored = true
        end
      else
        unless skip_line_comments && line.start_with?('//') && CommentLineRx =~ line
          result << line
          line_read = true
        end
      end
    end

    if restore_process_lines
      @process_lines = true
      @look_ahead -= 1 if line_restored && !terminator
    end
    result
  end

  # Internal: Shift the line off the stack and increment the lineno
  #
  # This method can be used directly when you've already called peek_line
  # and determined that you do, in fact, want to pluck that line off the stack.
  #
  # Returns The String line at the top of the stack
  def shift
    @lineno += 1
    @look_ahead -= 1 unless @look_ahead == 0
    @lines.shift
  end

  # Internal: Restore the line to the stack and decrement the lineno
  def unshift line
    @lineno -= 1
    @look_ahead += 1
    @eof = false
    @lines.unshift line
  end

  def cursor
    Cursor.new @file, @dir, @path, @lineno
  end

  # Public: Get information about the last line read, including file name and line number.
  #
  # Returns A String summary of the last line read
  def line_info
    %(#{@path}: line #{@lineno})
  end
  alias :next_line_info :line_info

  def prev_line_info
    %(#{@path}: line #{@lineno - 1})
  end

  # Public: Get a copy of the remaining Array of String lines managed by this Reader
  #
  # Returns A copy of the String Array of lines remaining in this Reader
  def lines
    @lines.dup
  end

  # Public: Get a copy of the remaining lines managed by this Reader joined as a String
  def string
    @lines * EOL
  end

  # Public: Get the source lines for this Reader joined as a String
  def source
    @source_lines * EOL
  end

  # Public: Get a summary of this Reader.
  #
  #
  # Returns A string summary of this reader, which contains the path and line information
  def to_s
    line_info
  end
end
end
