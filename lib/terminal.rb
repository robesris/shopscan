require 'shopscan'

class Terminal
  include ShopScan

  def add_item(item)
    @price_list ||= {}
    @price_list.merge! item
  end

  def product(product_name = nil)
    return self.all_products unless product_name

    @price_list[product_name.to_s.upcase]
  end

  def all_products
    @price_list
  end

  def items
    @items ||= []
  end

  def add_item_to_cart(item)
    @items ||= []
    @items << item
  end
end
