require 'csv'
class ReviewController < ApplicationController


  def index
    params[:page] ||= 1
    params[:per_page] ||= 20
    @nlps =  Nlp.need_approval.paginate(:page => params[:page], :per_page => params[:per_page])
    
     respond_to do |format|
       format.csv { render layout: false }
     end
  end
  
  
end