class User
	include MongoMapper::Document
	# keys
	key :twitter_display_name, String, :required => true, :unique => true
	key :twitteruid, String
	key :image_url, String
	key :followers, Integer
	key :del_followers, Integer
	key :following, Integer
	key :del_following, Integer
	key :twitter_created_at, Time
	key :created_at, Time
end