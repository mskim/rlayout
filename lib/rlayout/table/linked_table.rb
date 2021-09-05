module RLayout

  class LinkedTable < Table
    attr_reader :prev, :next

    def initialize(options={})
      @prev = options[:prev]

      self
    end
  end


end