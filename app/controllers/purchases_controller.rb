class PurchasesController < ApplicationController
  VALID_GATEWAY = ['paypal', 'stripe']
  def create
    return render_response('invalid_gateway') unless valid_gateway?
    cart_id = purchase_params[:cart_id]
    cart = Cart.find_by(id: cart_id)

    return render_response('invalid_cart') unless cart
    user = UserCreator.new(cart, purchase_params).call

    return render_response('invalid_user', user) unless user.valid?
    order = OrderInstantiator.new(user, address_params).call
    IncludeOrderItemsCreator.new(cart, order).call
    order.save

    if order.valid?
      render_response('valid_order', order)
    else
      render_response('invalid_order', order)
    end
  end


  private

  def purchase_params
    params.permit(
      :gateway,
      :cart_id,
      user: %i[email first_name last_name],
      address: %i[address_1 address_2 city state country zip]
    )
  end
  
  def address_params
    purchase_params[:address] || {}
  end

  def valid_gateway?
    VALID_GATEWAY.include?(purchase_params[:gateway])
  end
  
  def render_response(message_type, obj = nil)
    case message_type
    when 'invalid_gateway'
      render json: { errors: [{ message: 'Gateway not supported!' }] }, status: :unprocessable_entity      
    when 'invalid_cart'
      render json: { errors: [{ message: 'Cart not found!' }] }, status: :unprocessable_entity
    when 'invalid_order', 'invalid_user'
      render json: { errors: obj.errors.map(&:full_message).map { |message| { message: message } } }, status: :unprocessable_entity
    when 'valid_order'
      render json: { status: :success, order: { id: obj.id } }, status: :ok
    else
      puts 'Undefined render type!'
    end
  end
end
