require "twitter"
class UsersController < ApplicationController

	def index
		# raise request.env["omniauth.auth"].to_yaml This displays all information passed from twitter when app is given acess
		@user = User.all
	end

	def edit
	end


	def new
		@user = User.new(params[:user])

	end

	def create
		@user = User.new(params[:user])
		# This block of code is used to configure Access of this Application to the twitter API
		# I would prefer if this could be placed in a global file but this was changed in the Twitter Gem Update as it wasn't "thread safe"
		client = Twitter::REST::Client.new do |config|
			config.consumer_key = 'CONSUMER_KEY'
			config.consumer_secret = 'CONSUMER_SECRET'
			config.access_token = 'ACCESS_TOKEN'
			config.access_token_secret = 'ACCESS_TOKEN_SECRET'
		end
		# This serves as an easy marker when reading output form the server console in CMD line
		puts('............................................................................................')
		puts (@user.name)

		if (@user.name = client.user(@user.name).screen_name) # returns true or error ,not true or false
			@user.save										  # Saves the user object to MongoDB
			redirect_to users_path

			# else code has never been used remains untested
		else puts('user not found')
			redirect_to new_user_path
			flash[:notice] = 'Please Provide a Registered Twitter Username'
		end
	end
		# Failed attempts below to check if a username exists using Twitter gem. 
		# (Place inside create class if testing again)


		# puts client.user(@user.name).screen_name?
		# puts client.user@user.name.screen_name

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