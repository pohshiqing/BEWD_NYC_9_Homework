class PostsController < ApplicationController
	def index
		#binding.pry
		#@query = params['query'] #dynamically add pages
		#if params['query'] == 'cats'
		#	@query = 'Cats'
		#else
		#	@query = "Brooks".downcase
		#end
		@posts = Post.all

	end
	def show
		Post.find(params['id'])
	end
	def new
	end
	def create
	end
	def update
	end
	def destroy
	end
end
