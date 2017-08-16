class ReviewsController < ApplicationController
	before_action :require_login

	def require_login
    	@user = User.find_by(id: session["user_id"])
		if @user.blank?
			redirect_to "/sessions/new", notice: "Please login first."
		end
	end

	def index
		if params["search"]
			#users can only manage their own reviews
    		@reviews = Review.where(user_id: session["user_id"]).search(params["search"]).order("updated_at DESC")
  		else
    		@reviews = Review.where(user_id: session["user_id"]).order("updated_at DESC")
  		end
  		render "index"
	end

	def show
		@review = Review.find_by(id: params["id"])
		#users can only manage their own reviews
		if @review.present? && @review.user_id == session["user_id"]
			render "show"
		else
			redirect_to "/reviews", notice: "Authorization failure!"
		end
	end

	def new
		@review = Review.new
		render "new"
	end

	def create
		@review = Review.new
		@review.name = params["name"]
		@review.description = params["description"]
		@review.user_id = session["user_id"]
		if @review.save
			redirect_to "/reviews", notice: "Review successfully created."
		else
			flash[:notice] = "Error in creating review."
			render "index"
		end
	end

	def edit
		@review = Review.find_by(id: params["id"])
		#users can only manage their own reviews
		if @review.present? && @review.user_id == session["user_id"]
			render "edit"
		else
			redirect_to "/reviews", notice: "Authorization failure!"
		end
	end

	def update
		@review = Review.find_by(id: params["id"])
		if @review.present? && @review.user_id == session["user_id"]
    		@review.name = params["name"]
    		@review.description = params["description"]
    		if @review.save
      			redirect_to "/reviews/#{@review.id}", notice: 'Review successfully updated.'
    		else
      			render "edit"
    		end
    	else
			redirect_to "/reviews", notice: "Authorization failure!"
		end	
	end
	

	def destroy
		@review = Review.find_by(id: params["id"])
		#users can only manage their own reviews
		if @review.present? && @review.user_id == session["user_id"]
			@review.destroy
			redirect_to "/reviews"
		else
			redirect_to "/reviews", notice: "Authorization failure!"
		end		
	end


end