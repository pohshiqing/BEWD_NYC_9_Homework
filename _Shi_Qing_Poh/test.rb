
require 'json'
require 'rest-client'
require 'Vacuum'
#require 'amazon/aws'
 # require 'amazon/aws/search'
  require 'aws'

  include Amazon::AWS
  include Amazon::AWS::Search

  request = Request.new(KEY_ID)

gem install ruby-aaws
gem install aws-sdk
gem install aws


def search_amazon
	res = JSON.load(RestClient.get('http://webservices.amazon.com/AWSECommerceService/AWSECommerceService.wsdl'))
	res["data"]["feed"].map do |story|
		s = {title:story["content"]["title_alt"], description:story["content"]["description"]}
		#calculate_upvotes(s)
		#show_new_story_notification(s)
		#s
	end
end

 is = ItemSearch.new( 'Books', { 'Title' => 'ruby programming' } )

##########
gem install 'excon'
gem install 'rubygems'
gem install 'Vacuum'
gem install 'fog'
require 'rubygems'
require 'excon'
require 'Vacuum'
require 'fog'
req = Vacuum.new
#AKIAIJZEOBD4H4XGT3JA
req.configure(
    aws_access_key_id:     'AKIAIJZEOBD4H4XGT3JA',
    aws_secret_access_key: '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',
    associate_tag:         'tag'
)
params = {'SearchIndex' => 'Books','Keywords'    => 'Architecture'}
res = req.item_search(query: params)













