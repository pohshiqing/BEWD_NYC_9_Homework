class LikesController < ApplicationController
  def like
  	#binding.pry
  	Like.create(product_id: params[:product_id], user_id: current_user.id, userproduct_id: params[:redirect_id])
  	redirect_to products_matches_path(params[:redirect_id], :match_index => params[:match_index].to_i+1)
  	#binding.pry
  end

  def unlike
	Like.find_by(product_id: params[:product_id], user_id: current_user.id, userproduct_id: params[:redirect_id]).destroy
  	redirect_to products_matches_path(params[:redirect_id], :match_index => params[:match_index].to_i+1)
  	#binding.pry
  end

  def redirect
  	redirect_to products_matches_path(params[:redirect_id], :match_index => params[:match_index].to_i+1)
  end

end
