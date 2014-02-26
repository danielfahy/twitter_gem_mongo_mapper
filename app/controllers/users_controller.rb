require "twitter"
require 'rubygems'
require 'oauth'
require 'json'
require "net/http"
require 'jquery-rails'

class UsersController < ApplicationController



	def index
		# raise request.env["omniauth.auth"].to_yaml This displays all information passed from twitter when app is given acess
		@user = User.all
	end

	def show
	# This block of code is used to configure Access of this Application to the twitter API
	# I would prefer if this could be placed in a global file but this was changed in the Twitter Gem Update as it wasn't "thread safe"
	@client = Twitter::REST::Client.new do |config|
		config.consumer_key = '4tMJXmj7bH3ZJbXmiWg'
		config.consumer_secret = 'b7iR7Zem711cEpvtWBmHAxzosew2qkL6owqgXh49aY'
		config.access_token = '2317462262-wuKoJH5wTHmswWmkqeG9fT83MdzfK9SeJJjiiuW'
		config.access_token_secret = 'WCogO5xi5hzgiq6rtpgLwrweMSixqVFSRSfFYEgfbMOfa'
	end

		@user = User.find_by_twitter_display_name(params[:twitter_display_name])
		@timeline = @client.user_timeline(params[:twitter_display_name]).first(3)
	end

	def new
		@user = User.new(params[:user])
	end

	def create

	@userexist = User.find_by_twitter_display_name(params[:user][:twitter_display_name]) #Should be boolean really
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

		def authfailure
		end
end