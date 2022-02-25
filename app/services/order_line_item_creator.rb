class OrderLineItemCreator
  def initialize(order, item)
    @order = order
    @item = item
  end

  def call
    OrderLineItem.new(
      order: @order,
      sale: @item.sale,
      unit_price_cents: @item.sale.unit_price_cents,
      shipping_costs_cents: shipping_costs,
      paid_price_cents: @item.sale.unit_price_cents + shipping_costs
    )
  end

  def shipping_costs
    100
  end
end
