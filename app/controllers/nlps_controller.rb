class NlpsController < ApplicationController

  # GET /nlps/1
  # GET /nlps/1.json
  def show
    @nlp = Nlp.includes(:interests).find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @nlp }
    end
  end

  # GET /nlps/new
  # GET /nlps/new.json
  def new
    @nlp = Nlp.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @nlp }
    end
  end
  
  def index
    if params[:review]
      @nlps = Nlp.need_approval
    else
      @nlps = Nlp.all.limit(10)
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @nlps }
    end
  end

  # GET /nlps/1/edit
  def edit
    @nlp = Nlp.find(params[:id])
    @message = Message.new
    #@nlp.interests.each { |i| i.insights.build }
  end
  
  # POST /nlps
  # POST /nlps.json
  def create
    @nlp = Nlp.new(params[:nlp])

    respond_to do |format|
      if @nlp.save
        format.html { redirect_to @nlp, notice: 'Nlp was successfully created.' }
        format.json { render json: @nlp, status: :created, location: @nlp }
      else
        format.html { render action: "new" }
        format.json { render json: @nlp.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /nlps/1
  # PUT /nlps/1.json
  def update
    add_language_comments
    @nlp = Nlp.find(params[:id])
    
    respond_to do |format|
      if @nlp.update_attributes(params[:nlp])
        format.json { head :no_content }
        if params[:referring_controller_action] == "random_by_language"
          flash[:notice] =  'Record was successfully updated.'
          format.html { redirect_to controller: "nlps", action:  "random_by_language", language: params[:referring_language], id: nil }
        else
          flash[:notice] =  'Nlp was successfully updated.'
          format.html { redirect_to controller: "nlps", action: "index" }
        end
      else
        flash[:notice] = @nlp.errors.full_messages.to_sentence
        format.html { redirect_to controller: "nlps", action:  "random_by_language", language: params[:referring_language], id: @nlp.id }
      end
    end
  end

  # DELETE /nlps/1
  # DELETE /nlps/1.json
  def destroy
    @nlp = Nlp.find(params[:id])
    @nlp.destroy

    respond_to do |format|
      format.html { redirect_to nlps_url }
      format.json { head :no_content }
    end
  end
  
  def random_by_language
    @nlp = params[:id] ? Nlp.find(params[:id]) : Nlp.get_random_record_by_language(params[:language])
    @message = Message.new
    @random_interest = params[:interest_id] ? Interest.find(params[:interest_id]) : @nlp.interests[rand(@nlp.interests.length)] # get a random interest to display. 
    @random_interest.insights.build

    respond_to do |format|
      format.html { render action: 'edit' }
      format.json { render json: @nlp }
    end
  
  end
  
  
  protected
  
  
  def add_language_comments
    params["nlp"]["interests_attributes"].each do |interests_key, interests|
      if interests["insights_attributes"]
        interests["insights_attributes"].each do |insights_key, insights|
          ["role_language", "comment", "language_comment"].each do |field|
            if params["nlp"][field]
              insights[field] = params["nlp"][field] 
            end
          end
        end
      end
    end 
    params 
  end
    
    
  
end
