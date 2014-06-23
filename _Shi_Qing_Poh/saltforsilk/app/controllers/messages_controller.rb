class MessagesController < ApplicationController

  #before_action :authenticate_user!, only: [:new]
  def message_params
    params.require(:message).permit(:sender, :receiver, :content)
  end


  def index
  	@messages = Message.all
  end
  def show
  	@message = Message.new
  	@user = current_user
    @messages_user = Message.where("sender = #{@user.id} or receiver = #{@user.id} ")
  	#@sender = @user
  	#@receiver_product_id = params[:product_id]
  	#@receiver_product = Product.find_by(id: @receiver_product_id)

  end

  def new
    @message = Message.new
    @user = current_user
    @receiver_product_id = params[:product_id]
    @receiver_product = Product.find_by(id: @receiver_product_id)
    #@message.sender = @user.id
 	@message_receiver_id = Product.find_by(id: @receiver_product_id).user.id
  end

  def create
    @user = current_user
    @message = Message.new(message_params)
    

    #binding.pry
    respond_to do |format|
      if @message.save
        format.html { redirect_to @message, notice: 'Message was successfully sent.' }
        format.json { render :show, status: :created, location: @message }
      else
        format.html { render :new }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    #binding.pry
    end
  end


end
