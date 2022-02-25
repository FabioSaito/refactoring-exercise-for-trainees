class IncludeOrderItemsCreator
  def initialize(cart, order)
    @cart = cart
    @order = order
  end

  def call
    @cart.items.each do |item|
      item.quantity.times do
        @order.items << OrderLineItemCreator.new(@order, item).call
      end
    end
  end
end
