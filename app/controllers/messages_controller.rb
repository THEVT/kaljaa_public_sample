class MessagesController < ApplicationController

	before_filter :get_mailbox, :get_box, :get_profile
	
	def index
		redirect_to conversations_path(:box => @box)
	end

	# GET /messages/1
	# GET /messages/1.xml
	def show
		@conversation = mailbox.conversations.find(params[:id])

		if @message = Message.find_by_id(params[:id]) and @conversation = @message.conversation
			if @conversation.is_participant?(@profile)
				redirect_to conversation_path(@conversation, :box => @box, :anchor => "message_" + @message.id.to_s)
			return
			end
		end
		redirect_to conversations_path(:box => @box)
	end

	# GET /messages/new
	# GET /messages/new.xml
	def new

		if params[:receiver].present?
			@recipient = Profile.find_by_slug(params[:receiver])
			return if @recipient.nil?
			@recipient = nil if Profile.normalize(@recipient)==Profile.normalize(current_profile)
		end
	end

	# GET /messages/1/edit
	def edit

	end

	# POST /messages
	# POST /messages.xml
	def create
		@recipients = 
			if params[:_recipients].present?
				@recipients = params[:_recipients].split(',').map{ |r| Profile.find(r) }
			else
				[]
			end
		@catcher = Profile.find(2)
		@receipt = @profile.send_message(@catcher, params[:body], params[:subject])
		if (@receipt.errors.blank?)
			@conversation = @receipt.conversation
			flash[:success]= t('mailboxer.sent')
			redirect_to conversation_path(@conversation, :box => :sentbox)
		else
			render :action => :new
		end
	end

	# PUT /messages/1
	# PUT /messages/1.xml
	def update

	end

	# DELETE /messages/1
	# DELETE /messages/1.xml
	def destroy

	end

	private

	def get_mailbox
		@mailbox = current_profile.mailbox
	end

	def get_profile
		@profile = current_profile
	end

	def get_box
		if params[:box].blank? or !["inbox","sentbox","trash"].include?params[:box]
			@box = "inbox"
		return
		end
		@box = params[:box]
	end

end
