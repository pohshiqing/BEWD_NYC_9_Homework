class ProductsController < ApplicationController
 
  before_action :set_product, only: [:show]
  before_action :authenticate_user!, only: [:new]

  def index
  	@products = Product.all
    #@products = Product.where(:user_id = current_user_id)
    #binding.pry
  end

  def product_params
    params.require(:product).permit(:title, :description, :value_low, :value_high, :image)
	end

	def new
    @product = Product.new
    @user = current_user
  end

  def show
    @user = current_user
  end

  def create
    @user = current_user
    @product = Product.new(product_params)
    @product.user_id = @user.id
    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    #binding.pry
    end
  end

  def destroy
    #redirect_to users_path(params[:user_id])
    Product.find_by(id: params[:id], user_id: current_user.id).destroy
    if Like.find_by(product_id: params[:id]).present?
      Like.find_by(product_id: params[:id]).destroy
    end
    if Like.find_by(userproduct_id: params[:id]).present?
      Like.find_by(userproduct_id: params[:id]).destroy
    end
    redirect_to user_path(current_user)
  end

  def matches
    #binding.pry 
    @user = current_user
    @product = Product.find(params[:id])
    @current_value_low = @product.value_low
    @current_value_high = @product.value_high
   # @matched_products = Product.where.not(user_id: @user.id).where('value_low < ?', @current_value_high).includes(:user)

    @matched_products = Product.where.not(user_id: @user.id).where("cast(value_low as int) <  #{@current_value_high} and cast(value_high as int) >  #{@current_value_low}").includes(:user)
    
    @nearby_users =  current_user.nearbys(30,:select => "id") 
    @nearby_users_array = []
    @nearby_users.each{|u| @nearby_users_array << u} 
    @matched_products_updated = @matched_products.where(:user_id => @nearby_users_array)
    #@matched_products_updated_first = @matched_products.where(:user_id => @nearby_users_array).first

  #binding.pry
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product

      @product = Product.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
   

end
