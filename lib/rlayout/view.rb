require File.dirname(__FILE__) + '/view/graphic_view_svg'
require File.dirname(__FILE__) + '/view/paragraph_view_svg'
require File.dirname(__FILE__) + '/view/document_view_svg'

if RUBY_ENGINE =='macruby'
  require File.dirname(__FILE__) + '/view/graphic_view_mac'
  require File.dirname(__FILE__) + '/view/paragraph_view_mac'
  require File.dirname(__FILE__) + '/view/document_view_mac'
end