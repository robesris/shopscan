require 'terminal'

# helper method
def default_prices
  {'A' => { :price => 200, :bulk_qty => 4, :bulk_price => 700 },
   'B' => { :price => 1200 },
   'C' => { :price => 125, :bulk_qty => 6, :bulk_price => 600 },
   'D' => { :price => 15 }}
end


# basic functionality
describe Terminal do
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

  it "scans items and stores them as an array of product names" do
    terminal = Terminal.new
    terminal.set_pricing(default_prices)

    terminal.scan("A")
    terminal.scan("A")
    terminal.scan("C")
    terminal.scan("B")
    terminal.scan("D")

    terminal.items.should == [ "A", "A", "C", "B", "D" ]
  end

  it "correctly totals the minimal cases" do
    test_cases = [ { :list => "ABCDABAA", :expected => 3240 },
                   { :list => "CCCCCCC", :expected => 725 },
                   { :list => "ABCD", :expected => 1540 } ]
    
    test_cases.each do |test_case|
      terminal = Terminal.new
      terminal.set_pricing(default_prices)

      items = test_case[:list].split ""
      items.each do |item|
        terminal.scan(item)
      end

      terminal.total.should == test_case[:expected]
    end
  end
end
