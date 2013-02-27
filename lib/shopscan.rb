module ShopScan

  # storage and retrieval methods that should be implmented by the including class 
  def add_item(item)
    raise "Please implement the add_item method to add a new product given a hash of the form: { 'A' => { :price => PRICE_IN_CENTS, :bulk_qty => BULK_QTY, :bulk_price => BULK_PRICE } }"
  end

  def product(product_name = nil)
    raise "Please implement the product method, accepting a product name as a string."
  end

  def all_products
    raise "Please implement the all_products method, returning a hash of all products."
  end

  def items
    raise "Please implement the items method, to return an array of scanned item names."
  end

  def add_item_to_cart(item)
    raise "Please implement the add_item_to_cart(item) method, accepting an item name."
  end


  # core methods
  def set_pricing(price_list)
    price_list.each_pair do |key, product|
      self.add_item(key => product)
    end
  end

  def price_list(product_name = nil)
    if product_name
      self.product(product_name)
    else
      self.all_products
    end
  end

  def scan(item)
    if all_products[item]
      add_item_to_cart(item)
      { :status => :success }
    else
      { :status => :failed, :message => "Unknown product skipped: '#{item}'" }
    end
  end

  def total
    item_counts = {}

    self.items.each do |item|
      item_counts[item] ||= 0
      item_counts[item] += 1
    end

    total = 0
    item_counts.each_pair do |key, item_count|
      #raise @price_list.inspect
      if item_info = self.price_list[key]
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
