class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show, :profile]

  before_action :set_user, only: [:show, :update, :destroy]

  def profile
    @user = current_user
    @products_selected = @user.products
    @user[:IPAddress] = request.remote_ip
    @user.save
    @result = request.location

    #binding.pry
    render :show
  end

  def index
    @users = User.all
  end

  def new
    @user = current_user
  end

  def show
  	@user = User.find(params[:id])
  	@products_selected = @user.products
  	#@products_selected = Product.where(:user_id => @user.id)
  	#@products_selected = Product.where(user_id: @user.id)
  	#binding.pry

  end

  def destroy
    #redirect_to users_path(params[:user_id])
    User.find_by(id: params[:id]).destroy
    if Product.find_by(user_id: params[:id]).present?
      Product.find_by(user_id: params[:id]).destroy
    end
    redirect_to users_path
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  

     #redirect_to users_path
  private
    def set_user
      @user = User.find(params[:id])
    end
    def user_params
      params.require(:user).permit(:avatar)
    end
  
end
