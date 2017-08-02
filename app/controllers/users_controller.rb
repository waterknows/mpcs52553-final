class UsersController < ApplicationController
	def new
		if session["user_id"].present?
			redirect_to "/users/#{session[:user_id]}"
		else
			@user = User.new
		end
	end

	def create
		@user = User.new
		@user.email = params[:email]
		@user.name = params[:name]
		@user.password = params['password']
		if @user.save
			redirect_to "/sessions/new", notice: "Your account has been created!"
		else 
			flash[:notice] = "Your account could not be created. See below for more information."
			render "new"
		end
	end

	def update
		@user = User.find_by(id: params[:id])
		if session[:user_id].present? && @user.id == session["user_id"]
			@user.name = params[:name]
			if @user.save
				render "show"
			else
				flash[:notice] = "Could not change your username to '#{params[:name]}'."
				render "edit"
			end
		else
			reset_session
			redirect_to "/sessions/new"			
		end
		print params[:name]
	end

	def edit
		@user = User.find_by(id: params[:id])
		if session[:user_id].present? && @user.id == session["user_id"]
			render "edit"
		else 
			reset_session
			redirect_to "/sessions/new"
		end
	end

	def index
		if session[:user_id].present?
			redirect_to "/users/#{session[:user_id]}"
		else
			@user = User.new
			redirect_to "/sessions/new"
		end
	end

	def show
		@user = User.find_by(id: params[:id])
		if @user.present? && @user.id == session["user_id"]
			render "show"
		elsif session[:user_id].present?
			redirect_to "/users/#{session[:user_id]}"
		else
			redirect_to "/sessions/new"
		end		
	end

	def destroy
		@user = User.find_by(id: params[:id])
		if @user.present? && @user.id == session["user_id"]
			reset_session
			@user.destroy
			redirect_to root_url, notice: "You have deleted your account!"
		elsif session[:user_id].present?
			redirect_to "/users/#{session[:user_id]}", notice: "You cannot delete someone else's account!"
		else
			redirect_to "/sessions/new", notice: "You must sign in to delete your account!"
		end		
	end
end