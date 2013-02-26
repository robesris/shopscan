require 'terminal'

# basic functionality
describe Terminal, "#set_pricing" do
  it "returns an empty price list by default" do
    terminal = Terminal.new
    terminal.set_pricing.should be_empty
  end
end
