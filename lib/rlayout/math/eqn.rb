
# parse eqn string into nested Hash
# Elements are represent as Array, if they are series of + - =
# And it is represented as Hash if they need to be combined, sqrt, sub, sup etc...

# 1 + 2               => [1, + , 2]
# 1 over 2            => {:over => [1, 2]}
# sqrt 2 over 2       => {:over=> [{:sqrt => 2}, 2]} 
# sqrt {2 over 2}     => {:sqrt=> {:over => [2, 2]} 
# sqrt 2 +  sqrt x    => [{:sqrt=>2} + {:sqrt=>x} ]

# 1. first step is to flatten braces({}), from deepest level and way up.
#    and convert it to Hash by converting string into Array and calling to_hash to {} parts, 
#    and save it in a hash with key, with id, as level_#{depth}_#{id}}
# 2. Once we have flattened it all, convert it to an array.
# 3. replae elements with saved braces. 
# 4. And run to_hash to the flatted array for the final time.


OPERATORS_PRECEDENCE = %w{
dyad vec under bar tilde hat dot dotdot fwd back down up
fat roman italic bold size
sub sup sqrt over
from to
sum lim int} 

# over sqrt left right (these are group to the left )

FREGENT_OPERATIONS = {
  '1 over 2': "some",
  'sqrt 2': "some",
  '1 over sqrt 2': "some",
  '1 over {sqrt 2}': "some",
  '{sqrt 2} over 2': "some",
  'sqrt 2 over 2': "some",
}
EQN_Abbrebiation    = ['+-', 'pi']
EQN_OPERATORS_0     = ['sup', 'sub', 'sqrt',]
EQN_OPERATORS_1     = ['over', 'lim', 'sum']
EQN_OPERATORS_2     = ['+', '-', 'x', '/']
EQN_OPERATORS       = EQN_OPERATORS_0 + EQN_OPERATORS_1 + EQN_OPERATORS_2

module RLayout
  
  
  class EQNParser
    attr_accessor :eqn_string, :hash
    
    def initialize(eqn_string, options={})
      @eqn_string = eqn_string      
      flatten_eqn
      self
    end
    
    def flatten_eqn
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
        
  end
end

