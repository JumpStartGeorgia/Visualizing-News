class MessagesController < ApplicationController
  def new
    @message = Message.new
  end

  def create
    @message = Message.new(params[:message])
    if @message.valid?
      # send message
			ContactMailer.new_message(@message).deliver
			@email_sent = true
    end
    render "new"
  end
end
