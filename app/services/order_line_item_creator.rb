class OrderLineItemCreator
  SHIPPING_COST = 100
  def initialize(order, item)
    @order = order
    @item = item
  end

  def call
    OrderLineItem.new(
      order: @order,
      sale: @item.sale,
      unit_price_cents: @item.sale.unit_price_cents,
      shipping_costs_cents: SHIPPING_COST,
      paid_price_cents: @item.sale.unit_price_cents + SHIPPING_COST
    )
  end
end
