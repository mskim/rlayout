
# parse eqn string into nested Array and Hash combination.
# Elements are represent as Array, if they are series of + - =
# And non-linear elements, such as sqrt, sub, sup etc..., are represented as Hash.
# There are preecdence of operation as following

OPERATORS_PRECEDENCE = %w{
dyad vec under bar tilde hat dot dotdot fwd back down up
fat roman italic bold size
sub sup sqrt over
from to
sum lim int}

# 1 + 2               => [1, + , 2]
# 1 over 2            => {:over => [1, 2]}
# sqrt 2 over 2       => {:over=> [{:sqrt => 2}, 2]} 
# sqrt {2 over 2}     => {:sqrt=> {:over => [2, 2]} 
# sqrt 2 +  sqrt x    => [{:sqrt=>2} + {:sqrt=>x} ]

# over sqrt left right (these are group to the left to right, and rest oprators are processed from right to left )

# eqn parsing strategy
# 1. frist, flatten braces({}) from deepest level move up to next lebel of braces until we get rid of all braces.
# 2. Once we have flattened it all.
# 3. run to_hash to the flatted array for the final time.
# 4. to_hash first converts string into Array and replace Array elements with saved braced Hashes.

module RLayout
  
  
  class EQNParser
    attr_accessor :eqn_string, :hash
    
    def initialize(eqn_string, options={})
      @eqn_string = eqn_string      
      flatten_braces
      self
    end
    
    def flatten_braces
      @brace_hash = {}
      # get deepest nested brace.
      @braced_parts = @eqn_string.scan(/\{[^\{]*\}/)
      j = 0
      while @braced_parts.length > 0 
        @braced_parts.each_with_index do |braced, i|
          key               = "level:#{j}_#{i}"
          braced_inner      = braced.gsub("{", "")
          braced_inner.gsub!("}", "")
          @brace_hash[key]  = to_hash(braced_inner.split(" "))
          @eqn_string.gsub!(braced, key)
        end
        j += 1
        # look for more nested brace one level up
        @braced_parts = @eqn_string.scan(/\{[^\{]*\}/)
        # loop until we have no more braces.
      end
      flatten_array = @eqn_string.split(" ")
      # if @brace_hash.count > 0
      #   # we have braces to recover
      #   puts "we have braced elements"
      # end
      # final run 
      @hash = to_hash(flatten_array)
    end
    
    # covert given array into Hash or Array of operators
    # some oprator are parsed from left to right, "over", "sqrt", "left", "right" 
    # and rest are parsed from right to left
    def to_hash(flat_array)
      new_array = flat_array.dup
      OPERATORS_PRECEDENCE.each do |operator|
        if new_array.include?(operator)
          operator_count = new_array.count(operator)
          operator_count.times do
            #default mode is parsing from left to right, using index
            operator_index = new_array.index(operator)
            case operator
            when 'sub', 'sup'
              #parsed from right to left, using rindex
              operator_index = new_array.rindex(operator)
              operand = new_array.delete_at(operator_index + 1)
              if operand =~/^level:/
                operand = @brace_hash[operand]
              end
              new_array.delete_at(operator_index)
              base = new_array.delete_at(operator_index - 1)
              new_array.insert(operator_index - 1, {operator.to_sym=>[base,operand]})
            when 'sqrt'
              operand = new_array.delete_at(operator_index + 1)
              if operand =~/^level:/
                operand = @brace_hash[operand]
              end
              new_array.delete_at(operator_index)
              new_array.insert(operator_index, {operator.to_sym=>operand})
            when 'over'              
              denominator = new_array.delete_at(operator_index + 1)
              if denominator =~/^level:/
                denominator = @brace_hash[denominator]
              end
              
              new_array.delete_at(operator_index)
              nominator = new_array.delete_at(operator_index - 1)
              if nominator =~/^level:/
                nominator = @brace_hash[nominator]
              end
              new_array.insert(operator_index - 1, {:over=>[nominator, denominator]})
            when 'from', 'to'
              operand = new_array.delete_at(operator_index + 1)
              if operand =~/^level:/
                operand = @brace_hash[operand]
              end
              new_array.delete_at(operator_index)
              new_array.insert(operator_index, {operator.to_sym=>operand})
              
            when 'lim', 'sum', 'int', 'prod', 'union', 'inter'
              from = nil; to = nil
              if new_array[operator_index + 1].keys.first == :from
                from  = new_array.delete_at(operator_index + 1)
                if  new_array[operator_index + 1].keys.first == :to
                  to      = new_array.delete_at(operator_index + 1)
                  operand = new_array.delete_at(operator_index + 1)
                  new_array.delete_at(operator_index)
                  new_array.insert(operator_index, {operator.to_sym=>[from, to, operand]})
                else
                  new_array.delete_at(operator_index)
                  operand = new_array.delete_at(operator_index)
                  new_array.insert(operator_index, {operator.to_sym=>[from, operand]})
                end
              elsif new_array[operator_index + 1].keys.first == :to
                  to = new_array.delete_at(operator_index + 1)
                  operand = new_array.delete_at(operator_index + 1)
                  new_array.delete_at(operator_index)
                  new_array.insert(operator_index, {operator.to_sym=>[to, operand]})
              end
              
            when 'left', 'right'
            
            else

            end
          end
        end
      end
      
      if new_array.length == 1
        new_array.first
      else
        new_array
      end
    end
    
    def to_ml(eqn_hash)
      math_ml = ""
      if eqn_hash.class == Array
        math_ml += "<mrow>\n"
          eqn_hash.each do |seg|
            math_ml += to_ml(seg)
          end
        math_ml += "</mrow>\n"
        
      elsif eqn_hash.class == Hash
        puts 
        operator = eqn_hash.keys.first
        case operator          
        when :sqrt
        when :over
          puts "over"
          math_ml += "<mover>\n"
          math_ml += "  " + to_ml(eqn_hash.values[0][0])
          math_ml += "  " + to_ml(eqn_hash.values[0][1])
          math_ml += "<mover>\n"
        when :sub
        when :sup
          
        end
        
      elsif eqn_hash.class == String
        puts "handleing when eqn_hash is String"
        puts "eqn_hash:#{eqn_hash}"
        #TODO check for number or alphabet
        if eqn_hash =~/\d/
          math_ml = "<mn>#{eqn_hash}</mn>\n"
        elsif eqn_hash =~/[a-zA-Z]/
          math_ml = "<mi>#{eqn_hash}</mi>\n"
        else
          math_ml = "<mo>#{eqn_hash}</mo>\n"
        end
      end
      math_ml
    end
    
    def to_math_ml
      puts __method__
      puts "@hash:#{@hash}"
      math_ml = "<math>\n"
      math_ml +=  to_ml(@hash)
      math_ml += "</math>\n"
    end
    
    def self.from_hash(hash)
      
    end
        
  end
end

