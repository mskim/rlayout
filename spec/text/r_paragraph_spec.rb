require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe "create RParagraph" do
  before do
    options                 = {}
    options[:string]        = 'This'
    options[:style_name]     = 'body'
    @r_token = RTextToken.new(options)
  end

end
