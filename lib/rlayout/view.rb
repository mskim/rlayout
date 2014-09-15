require File.dirname(__FILE__) + '/view/document_view_svg.rb'
require File.dirname(__FILE__) + '/view/graphic_view_svg.rb'

if RUBY_ENGINE =='macruby'
  require File.dirname(__FILE__) + '/view/document_view_mac.rb'
  require File.dirname(__FILE__) + '/view/graphic_view_mac.rb'
end