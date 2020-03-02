require 'thor'
module RLayout
  class CLI < Thor
    
    desc "display about", "Tells that it is working"
    def about
      puts "This is RLayout CLI"
    end
  end
end