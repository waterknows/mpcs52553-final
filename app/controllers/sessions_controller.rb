class SessionsController < ApplicationController
	def new
	end

	def create
		u = User.find_by(email: params["email"])
		if !u.nil?
			if u.authenticate(params["password"])
				session["user_id"] = u.id
				redirect_to "/documents", notice: "Welcome back, #{u.name}!"
			else
				redirect_to "/sessions/new", notice: "Wrong email/password pair!"
			end
		else
			redirect_to "/sessions/new", notice: "Unknown account!"
	    end
	end

	def index
		redirect_to "/sessions/new"
	end

	def show
		redirect_to "/users/#{params[:id]}"
	end

	def destroy
		reset_session
		redirect_to root_url, notice: "You have successfully signed out!"
	end
end
