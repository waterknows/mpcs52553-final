class ReviewsController < ApplicationController
	def new
		@review = Review.new
		@user = User.find_by(id: session["user_id"])
		if @user.present?
			render "new"
		else
			reset_session
			redirect_to "/sessions/new"
		end	
	end

	def index
		@review = Review.new
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
			@review = Review.new
			@review.name = params[:name]
			@review.description = params[:description]
			@review.user_id = session[:user_id]
			if @review.save
				redirect_to "/reviews", notice: "Review successfully created."
			else
				flash[:notice] = "Error in creating review."
				render "index"
			end
		else
			reset_session
			redirect_to "/sessions/new"
		end
	end


	def show
		@review = Review.find_by(id: params[:id])
		@user = User.find_by(id: session["user_id"])
		if @user.present? && @review.present? && @review.user_id == @user.id
			render "show"
		else
			reset_session
			redirect_to "/sessions/new"
		end
	end

	def destroy
		@review = Review.find_by(id: params[:id])
		@user = User.find_by(id: session["user_id"])
		if @user.present? && @review.present? && @review.user_id == @user.id
			@review.destroy
			redirect_to "/reviews"
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