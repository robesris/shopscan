require 'shopscan'

class Terminal
  include ShopScan

  def add_item(item)
    @price_list ||= {}
    @price_list.merge! item
  end

  def price_list(product_name = nil)
    if product_name
      @price_list[product_name.to_s.upcase]
    else
      @price_list
    end
  end

  def items
    @items ||= []
  end

  def scan(item)
    @items ||= []
    @items << item
  end

  def total
    item_counts = {}

    @items.each do |item|
      item_counts[item] ||= 0
      item_counts[item] += 1
    end

    total = 0
    item_counts.each_pair do |key, item_count|
      #raise @price_list.inspect
      if item_info = @price_list[key]
        if (bulk_qty = item_info[:bulk_qty]) && bulk_price = item_info[:bulk_price]
          total += item_count / bulk_qty * bulk_price
          item_count %= bulk_qty
        end
        total += item_count * item_info[:price]
      end
    end

    total
  end
end
