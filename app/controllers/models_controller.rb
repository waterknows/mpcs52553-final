class ModelsController < ApplicationController
	before_action :require_login

	def require_login
    	@user = User.find_by(id: session["user_id"])
		if @user.blank?
			redirect_to "/sessions/new", notice: "Please login first."
		end
	end

 	def index
  	end

  	def show
  	end


end