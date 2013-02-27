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

  it "gracefully rejects unknown items with a warning" do
    terminal = Terminal.new
    terminal.set_pricing(default_prices)

    terminal.scan('A')[:status].should == :success

    # unknown product
    result = terminal.scan('E')
    result[:status].should == :failed
    result[:message].should == "Unknown product skipped: 'E'"

    # case sensitive
    result = terminal.scan('a')
    result[:status].should == :failed
    result[:message].should == "Unknown product skipped: 'a'"

    result = terminal.scan('B')
    result[:status].should == :success
    result[:message].should be_nil

    result = terminal.scan('ABCD')
    result[:status].should == :failed
    result[:message].should == "Unknown product skipped: 'ABCD'"

    terminal.items.should == [ 'A', 'B' ]
    terminal.total.should == 1400
  end

  it "correctly totals all 'carts' of length #{ENV['LIST_LENGTH'] || 1}" do
    list_length = ENV['LIST_LENGTH'] || 1

    terminal = Terminal.new
    terminal.set_pricing(default_prices)
    
    item_names = terminal.price_list.map { |key, item| key }

    list_length = list_length.to_i
    if list_length >= 1
      old_combos = [ { :list => "", :value => 0, 'A' => 0, 'B' => 0, 'C' => 0, 'D' => 0 } ]
      1.upto(list_length) do |length|
        new_combos = []
        puts "\nLENGTH #{length}:"
        old_combos.each do |old_combo|
          item_names.each do |item_name|
            new_combo = { :list => old_combo[:list] + item_name, 
                          :value => nil, # we're going to recalculate
                          'A' => old_combo['A'],
                          'B' => old_combo['B'],
                          'C' => old_combo['C'],
                          'D' => old_combo['D']
                        }
            new_combo[item_name] += 1
            
            combo_value = 0

            terminal = Terminal.new
            terminal.set_pricing(default_prices)
            'A'.upto('D') do |combo_item_name|
              combo_item = terminal.price_list[combo_item_name]
              bulk_qty = combo_item[:bulk_qty]
              bulk_price = combo_item[:bulk_price]
              remaining = new_combo[combo_item_name]

              if bulk_qty && bulk_price
                combo_value += remaining / bulk_qty * bulk_price
                remaining %= bulk_qty
              end
              combo_value += remaining * combo_item[:price]
            end
            new_combo[:value] = combo_value

            # now scan and check against expected values
            items = new_combo[:list].split ""
            items.each do |item|
              terminal.scan(item)
            end

            # moment of truth...
            grand_total = terminal.total
            result_s = if grand_total == new_combo[:value]
              "*** PASSED:"
            else
              "!!! FAILED:"
            end

            puts "#{result_s} Expected: #{new_combo[:value]}\tActual: #{grand_total}\tCart: #{new_combo[:list]}"

            # the actual test
            grand_total.should == new_combo[:value]

            new_combos << new_combo
          end
        end
        old_combos = new_combos
      end
    end
  end
end
