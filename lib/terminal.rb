class Terminal
  def set_pricing(price_list)
    @price_list = price_list
  end

  def price_list(product_name = nil)
    if product_name
      @price_list[product_name.to_s.upcase]
    else
      @price_list
    end
  end
end
