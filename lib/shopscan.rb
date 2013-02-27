module ShopScan
  def set_pricing(price_list)
    price_list.each_pair do |key, product|
      self.add_item(key => product)
    end
  end

  def add_item(item)
    raise "Please implement the add_item method to add a new product given a hash of the form: { 'A' => { :price => PRICE_IN_CENTS, :bulk_qty => BULK_QTY, :bulk_price => BULK_PRICE } }"
  end
end
