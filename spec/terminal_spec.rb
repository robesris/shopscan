require 'terminal'

# basic functionality
describe Terminal, "#set_pricing" do
  it "allows us to set and retrieve pricing" do
    terminal = Terminal.new
    expect {terminal.set_pricing({'A' => { :price => 200, :bulk_qty => 4, :bulk_price => 700 },
                                  'B' => { :price => 1200 },
                                  'C' => { :price => 125, :bulk_qty => 6, :bulk_price => 600 },
                                  'D' => { :price => 15 }}) }.to_not raise_error
    terminal.price_list['A'][:price].should == 200
    terminal.price_list['A'][:bulk_qty].should == 4
    terminal.price_list['B'][:price].should == 1200
    terminal.price_list(:c)[:price].should == 125
    terminal.price_list('C')[:bulk_price].should == 600
    terminal.price_list('d')[:price].should == 15
  end
end
