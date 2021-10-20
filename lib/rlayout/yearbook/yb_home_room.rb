module RLayout
  class HomeRoom
    attr_reader :name, :teacher :number_of_group

    def initialize(options={})
      @name = options[:name]
      @teacher = options[:teacher]
      @number_of_group = options[:number_of_group]
      
      self
    end

  end



end