#AMAZON API
###terminal
gem install 'excon'
gem install 'rubygems'
gem install 'Vacuum'
gem install 'fog'
### irb
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





