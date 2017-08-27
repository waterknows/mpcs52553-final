class DocumentsController < ApplicationController
	before_action :require_login

	
	def require_login
    	@user = User.find_by(id: session["user_id"])
		if @user.blank?
			redirect_to "/sessions/new", notice: "Please login first."
		end
	end

	def document_params
    	if params[:document]
      		params.require(:document).permit(:id,:name, :description, tags_attributes: [:id,:_destroy,:topic,:color,:modified]) 
    	end
  	end

  	def tag_documents(docs)
  		if docs.present?
	  		topics = ['Machine Learning','Computer Graphics','Computer Architecture, Processor','Computer Programmng','Computer Network, Scheduling','Formal Language','Network Security','Algorithm','Database, Information Retrieval','Computer Network, Routing','Distributed System, Mobile','Computer Architecture, Memory','Computer Mathematics','Computer Education','UX Design','Research','Game Theory, Decision Theory','Data Analysis','Computer Organization, Design','Graph Theory']
			colors = [ "#1f77b4", "#aec7e8", "#ff7f0e", "#ffbb78", "#2ca02c", "#98df8a", "#d62728", "#ff9896", "#9467bd", "#c5b0d5", "#8c564b", "#c49c94", "#e377c2", "#f7b6d2", "#7f7f7f", "#c7c7c7", "#bcbd22", "#dbdb8d", "#17becf", "#9edae5" ]

			s = docs.pluck('description').join("===").tr('"','')
			tags_str = `python python/similar_doc.py lda apply \"#{s}\"`
			tags_int = tags_str.tr('[]', '').split(',').map(&:to_i)
			tags_topic = tags_int.map{|tag| topics[tag]}
			tags_color = tags_int.map{|tag| colors[tag]}

			docs.zip(tags_topic, tags_color).each do |d,tt,tc|
				t = Tag.new
				t.document_id = d.id
				t.topic = tt
				t.color = tc
				t.tagged_by_model = true
				t.save
			end
		end
	end


	def index
		@documents = Document.order("documents.updated_at DESC")
		user = User.find_by(id: session["user_id"])
		if user.privilege == 'admin'
			if params["search"].to_s.downcase == "tag empty"
				docs = @documents.includes(:tags).where(tags: {topic:nil})
				tag_documents(docs)
			elsif params["search"].to_s.downcase == "tag all"
				docs = @documents.where.not(id: @documents.includes(:tags).where(tags: {tagged_by_model:true}).pluck("id"))
				tag_documents(docs)
	  		elsif params["search"].to_s.downcase == "clean model"
	  			Tag.where(tagged_by_model: true).delete_all
	  		elsif params["search"].to_s.downcase == "clean user"
	  			Tag.where(tagged_by_model: false).delete_all
	  		elsif params["search"].to_s.downcase == "clean all"
	  			Tag.delete_all
	  		elsif params["search"]
	  			flash[:notice] = "Unknown command!"
	  		end
	  	else
	  		if params["search"]
	  			flash[:notice] = "Not enough previlege to run commands!"
	  		end
	  	end
  		render "index"
	end

	def show
		@document = Document.find_by(id: params["id"])


		if @document.present?
			render "show"

		else
			redirect_to "/documents", notice: "Cannot find requested document!"
		end
	end

	def new
		@document = Document.new
		render "new"
	end

	def create
 		@document = Document.new(document_params)
 		@document.user_id = session["user_id"]
	    if @document.save
	      	redirect_to "/documents", notice: "Document successfully created."
	    else
			render "new"
	    end
	end

	def edit
		@document = Document.find_by(id: params["id"])
		user = User.find_by(id: session["user_id"])
		#users can only manage their own documents
		if user.privilege == 'admin'
			if @document.present?
				render "edit"
			else
				redirect_to "/documents", notice: "Cannot find requested document!"
			end

		else
			if @document.present? && @document.user_id == session["user_id"]
				render "edit"
			else
				redirect_to "/documents", notice: "Not enough previlege to edit others' data!"
			end
		end
	end

	def update
		@document = Document.find_by(id: params["id"])
		user = User.find_by(id: session["user_id"])
		if user.privilege == 'admin'
			if @document.present?
	    		if @document.update_attributes(document_params)
	      			redirect_to "/documents/#{@document.id}", notice: 'Document successfully updated.'
	    		else
	      			render "edit"
	    		end
	    	else
				redirect_to "/documents", notice: "Cannot find requested document!"
			end	
		else
			if @document.present? && @document.user_id == session["user_id"]
	    		if @document.update_attributes(document_params)
	      			redirect_to "/documents/#{@document.id}", notice: 'Document successfully updated.'
	    		else
	      			render "edit"
	    		end
	    	else
				redirect_to "/documents", notice: "Not enough previlege to update others' data!"
			end	
		end
	end


	def destroy
		@document = Document.find_by(id: params["id"])
		user = User.find_by(id: session["user_id"])
		#users can only manage their own documents
		if user.privilege == 'admin'
			if @document.present?
				@document.destroy
				redirect_to "/documents", notice: 'Document successfully deleted.'
			else
				redirect_to "/documents", notice: "Cannot find requested document!"
			end
		else
			if @document.present? && @document.user_id == session["user_id"]
				@document.destroy
				redirect_to "/documents", notice: 'Document successfully deleted.'
			else
				redirect_to "/documents", notice: "Not enough previlege to delete others' data!"
			end
		end			
	end


end