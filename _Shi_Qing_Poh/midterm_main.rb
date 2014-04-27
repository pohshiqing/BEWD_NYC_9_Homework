
class User
	attr_accessor :name,:graph, :profile, :friends, :feed, :home, :user_id
  
 	def initialize(name, graph) # error somewhere
 		@name = name
	   	@graph = graph
		@profile = graph.get_object("me")
		@friends = graph.get_connection("me","friends")
		@user_id = friends.select {|friend| friend["name"] == name }[0]["id"]
		@user_posts = graph.get_connection(user_id,"feed")
		@home = graph.get_connection("me","home")
		
  	end

  	def get_userid
  		#user_id = friends.select {|friends| friends["name"] == "Belinda Ngor" }[0]["id"]
  		user_id
  	end

  	def get_userposts
  		user_posts
  	end

  	def get_userlikes

  		user_likes = graph.get_connection(user_id,"likes")
  		likes = user_likes.map{|like| like["name"]}
  	end

  	def get_usershares

  		user_posts = graph.get_connection(user_id,"feed")
  		#user_posts.map do |post|
  		#	stories = post["story"]
		#end
		stories = user_posts.map{|post| post["story"]}
  	end
  	def get_usermessages

  		user_posts = graph.get_connection(user_id,"feed")
  		#user_posts.map do |post|
  		#	message = post["message"]
		#end
		messages = user_posts.map{|post| post["message"]}
			
  	end
  	def get_userprofile
  		user_profile = graph.get_object(user_id)
  	end


end

class User_Duediligence
	attr_accessor :messages,:stories, :likes
	def initialize(messages, stories, likes)
 		@messages = messages
	   	@stories = stories
		@likes = likes	
  	end

  	def get_user_nouns_phrases
  		tgr = EngTagger.new

		#messages_combined = messages.join(', ')
		#stories_combined = stories.join(', ')
		likes_combined = likes.join(', ')
		#info_combined = [messages_combined,stories_combined,likes_combined].join(', ')
  		#tagged = tgr.add_tags(info_combined)
  		#tagged = tgr.add_tags(likes_combined)
  		#nouns_phrases = tgr.get_noun_phrases(tagged) #how to save results?
  		#nouns_phrases = likes_combined
  		nouns_phrases = likes
  	end
end

class Product_Suggest
	attr_accessor :nouns_phrases

	def initialize(nouns_phrases)
		@nouns_phrases = nouns_phrases
	end

	def find_relevant_products
		req = Vacuum.new
		#AKIAIJZEOBD4H4XGT3JA
		# should i put in initialize
		req.configure( aws_access_key_id:     'AKIAIJZEOBD4H4XGT3JA', aws_secret_access_key: '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', associate_tag:         'tag')
		nouns_phrases_array = nouns_phrases.to_a
		hash_products = []
		array = nouns_phrases_array.map do |phrase|
			params = {'SearchIndex' => 'Blended','Keywords' => phrase}
			x = req.item_search(query: params).to_h
			products_asin = x["ItemSearchResponse"]["Items"]["SearchResultsMap"]["SearchIndex"][0]["ASIN"]
			products_names = products_asin.map do |product_asin|
				y = req.item_lookup(query: { 'IdType' => 'ASIN', 'ItemId' => product_asin}).to_h
				product_name = y["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Title"]
				product_link = ["http://www.amazon.com/dp/",product_asin].join
				hash_products << {"Link" => product_link, "Product" => product_name}
				
			end
			binding.pry

			

		end	
	end

end

class Restaurant_Suggest
end


##### MAIN
require 'koala'
require 'rubygems'
require 'engtagger'
require 'excon'
require 'Vacuum'
require 'fog'
require 'pry'

#https://developers.facebook.com/tools/explorer?method=GET&path=me%3Ffields%3Did%2Cname
#puts "go to https://developers.facebook.com/tools/explorer?method=GET&path=me%3Ffields%3Did%2Cname and obtain your access token"
#puts "Copy and Paste Token below"
#access_token = gets.chomp
access_token = 'CAACEdEose0cBAK01ZABsJZAu88imxAEncadobfqJTQEUGbJAdZAnZAAvQx0MmGRJmZBnNtgKIuCUWmDwjUrtz7978SJdZBwkPl8se0HYRBZBp8aTUvhCuRbA4wW8GZBOeaLkEhRwRZAymOZCx3qZAKY9nJFxviIeaFn7FBUkFThiZB1UwgJvbRpR7SX5gdBmR4gmbPCVZALY1fhq8GwZDZD'	
#oauth = Koala::Facebook::OAuth.new("629003873819689", "91e4ff8447aef962c4ced9d3c1eb285e", nil)
# access_token = oauth.get_app_access_token
graph = Koala::Facebook::API.new(access_token)
#binding.pry
puts "Enter your friend's name"
name = gets.chomp

#name = "Jenny Z. Lin"
puts name
jenny = User.new(name, graph)
puts jenny.get_userid
likes = jenny.get_userlikes
stories = jenny.get_usershares
messages = jenny.get_usermessages

puts likes
puts stories
puts messages

jenny_profile = User_Duediligence.new(likes,stories,messages)

puts jenny_profile.get_user_nouns_phrases

#jenny_product_suggest = Product_Suggest.new(jenny_profile.get_user_nouns_phrases)
#puts jenny_product_suggest.find_relevant_products





