module ShopScan
  def set_pricing(price_list)
    price_list.each_pair do |key, product|
      self.add_item(key => product)
    end
  end

  def add_item(item)
    raise "Please implement the add_item method to add a new product given a hash of the form: { 'A' => { :price => PRICE_IN_CENTS, :bulk_qty => BULK_QTY, :bulk_price => BULK_PRICE } }"
  end

  def price_list(product_name = nil)
    if product_name
      self.product(product_name)
    else
      self.all_products
    end
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
end
