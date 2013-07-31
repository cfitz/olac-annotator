class HomeController < ApplicationController
  def index
    @users = User.all
  end
  
  # just show the examples page.
  # not using this now..just serving pdf, but i bet we'll have to convert that pdf to a page sometime, so leaving this here now...
  def examples
    render "examples"
  end
  
  def credits
    render "credits"
  end
  
  def about
    render "about"
  end
  
  def more
    render "more"
  end
  
end
