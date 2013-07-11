class ContactController < ApplicationController

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(params[:message])
    ( nlp_id, language) = @message.subject.split(" -- ").collect { |c| c.strip }
    if @message.valid?
      flash.notice = "Thank you for the comment!"
      InterestMailer.new_message(@message).deliver
      redirect_to "/nlps/random/#{language}/#{nlp_id}"
    else
      flash.alert = "Please fill the name and email fields in the contact form."
      redirect_to "/nlps/random/#{language}/#{nlp_id}"
    end
  end

end