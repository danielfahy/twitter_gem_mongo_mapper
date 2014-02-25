require "twitter"
require 'rubygems'
require 'oauth'
require 'json'
require "net/http"

class UsersController < ApplicationController



	def index
		# raise request.env["omniauth.auth"].to_yaml This displays all information passed from twitter when app is given acess
		@user = User.all
	end

	def edit
	end

	def show
		@user = User.find_by_twitter_display_name(params[:twitter_display_name])
		puts params 																#Used for testing!!!
	end

	def new
		@user = User.new(params[:user])
	end

	def create
		# # Check if username of twitter object exists already in Database and assign to model
		# if User.find_by_twitter_display_name(params[:user][:twitter_display_name])
		# 	@user = User.find_by_twitter_display_name(params[:user][:twitter_display_name])
		# 	flash[:notice] = @user.twitter_display_name.to_s + ' updated'

		# else
		# 	@user = User.new(params[:user])

		# end
		#check if this sessions user has been previously stored in DB
			@userexist = User.find_by_twitter_display_name(params[:user][:twitter_display_name])
			puts @userexist
	@user = User.find_or_create_by_twitter_display_name(params[:user][:twitter_display_name])

	# This block of code is used to configure Access of this Application to the twitter API
	# I would prefer if this could be placed in a global file but this was changed in the Twitter Gem Update as it wasn't "thread safe"
	@client = Twitter::REST::Client.new do |config|
		config.consumer_key = '4tMJXmj7bH3ZJbXmiWg'
		config.consumer_secret = 'b7iR7Zem711cEpvtWBmHAxzosew2qkL6owqgXh49aY'
		config.access_token = '2317462262-wuKoJH5wTHmswWmkqeG9fT83MdzfK9SeJJjiiuW'
		config.access_token_secret = 'WCogO5xi5hzgiq6rtpgLwrweMSixqVFSRSfFYEgfbMOfa'
	end
	#create local instance of twitter user object
	@twitobj=@client.user(@user.twitter_display_name) 
	#create local instance of mongodb user object
	@mongoobj= User.find_by_twitter_display_name(params) 


rescue Twitter::Error::NotFound
    # .. handle error thrown by trying to access non existant twitter user
    redirect_to new_user_path()
    flash[:notice] = @user.twitter_display_name.to_s + ' is not a registered TwitterID, try again'


else # if no exceptions occur assign variables from twitter object to @user and save to database

    	#If user previously existed track changes in followers/following count
    	if @userexist
    		@user.del_followers = @twitobj.followers_count - @user.followers
    		@user.del_following = @twitobj.friends_count - @user.following
    		@user.followers = @twitobj.followers_count
    		@user.following = @twitobj.friends_count
    	#If user previously did not exist save required info to DB
    	else
    		@user.twitteruid=@twitobj.id
    		@user.image_url = @twitobj.profile_image_url
    		@user.followers = @twitobj.followers_count
	    	@user.following = @twitobj.friends_count
	    	@user.twitter_created_at = @twitobj.created_at
	    	@user.created_at = Time.now

    	end

		@user.save
		redirect_to users_show_path(params[:user])

end

	# 	if (@user.twitter_display_name = client.user(@user.twitter_display_name).screen_name) # returns true or error ,not true or false
	# 		@user.save										  # Saves the user object to MongoDB
	# 		redirect_to users_path

	# 		# else code has never been used remains untested
	# 	else puts('user not found')
	# 		redirect_to new_user_path
	# 		flash[:notice] = 'Please Provide a Registered Twitter Username'
	# 	end
	# end

# 	def parse_user_response(response)
#   user = nil

#   # Check for a successful request
#   if response.code == '200'
#     # Parse the response body, which is in JSON format.
#     # ADD CODE TO PARSE THE RESPONSE BODY HERE
#     # user = response.body.JSON.parse

#     # Pretty-print the user object to see what data is available.
#     # puts "Hello, #{user["screen_name"]}!"
#   else
#     # There was an error issuing the request.
#     puts "Expected a response of 200 but got #{response.code} instead"
#   end

#   user
# end

# 	def create
# 		@user = User.new(params[:user])

# 		if @user.save										  # Saves the user object to MongoDB
# 			redirect_to users_path

# 		end

		# 		response = nil
		# Net::HTTP.start('www.google.ie', 80) {|http|
		# 	response = http.head('/index.html')
		# }
		# p response.code

		# Failed attempts below to check if a username exists using Twitter gem. 
		# (Place inside create class if testing again)

		# server_response= open('https://twitter.com/daniel_fahy')
		# puts server_response.status


		# puts client.user(@user.twitter_display_name).screen_name?
		# puts client.user@user.twitter_display_name.screen_name

		# if client.user.screen_name? # returns true or error, not true or false
		# 	puts 'shes real JACK '
		# else
		# 	puts 'she not real JACK'
		# end

				# if @user.save
		# 	redirect_to users_path
		# else
		# 	redirect_to new_user_path
		# 	flash[:notice] = 'Please Provide a Valid Twitter Username'
		# end

		def authfailure
		end
end