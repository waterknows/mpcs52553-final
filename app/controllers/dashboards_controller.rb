class DashboardsController < ApplicationController
	def index
		@dashboard = Dashboard.new
		@user = User.find_by(id: session["user_id"])
		if @user.present?
			render "index"
		else
			reset_session
			redirect_to "/sessions/new"
		end		
	end

	def create
		@user = User.find_by(id: session["user_id"])
		if @user.present?
			@dashboard = Dashboard.new
			@dashboard.name = params[:name]
			@dashboard.description = params[:description]
			@dashboard.user_id = session[:user_id]
			if @dashboard.save
				redirect_to "/dashboards", notice: "Your dashboard '#{@dashboard.name}' has been created."
			else
				flash[:notice] = "Your dashboard could not be created. See below for more information."
				render "index"
			end
		else
			reset_session
			redirect_to "/sessions/new"
		end
	end

	# new dashboard form is found on same page as index
	def new
		redirect_to "/dashboards"
	end

	def show
		@dashboard = Dashboard.find_by(id: params[:id])
		@user = User.find_by(id: session["user_id"])
		if @user.present? && @dashboard.present? && @dashboard.user_id == @user.id
			render "show"
		else
			reset_session
			redirect_to "/sessions/new"
		end
	end

	def destroy
		@dashboard = Dashboard.find_by(id: params[:id])
		@user = User.find_by(id: session["user_id"])
		if @user.present? && @dashboard.present? && @dashboard.user_id == @user.id
			@dashboard.destroy
			redirect_to "/dashboards"
		else
			reset_session
			redirect_to "/sessions/new"
		end		
	end

	def edit
	end

	def update
	end
end