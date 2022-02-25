class UserCreator
  def initialize(cart, purchase_params)
    @cart = cart
    @purchase_params = purchase_params
  end

  def call
    if @cart.user.nil?
      user_params = @purchase_params[:user] ? @purchase_params[:user] : {}
      User.create(**user_params.merge(guest: true))
    else
      @cart.user
    end
  end
end
