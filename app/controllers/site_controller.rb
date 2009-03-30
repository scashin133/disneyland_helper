class SiteController < ApplicationController
  include DisneylandHelper
  
  skip_before_filter :verify_authenticity_token
  after_filter :change_content_type, :only =>[:txt]
  
  def index

    @user = User.new
    @user.generate_uuid
    
  end

  def txt
    
    uuid = params[:uid]
    
    # Since Disney is in California this just kinda makes sense.
    Time.zone = "Pacific Time (US & Canada)"
    
    case params[:event]
    when "SUBSCRIPTION_UPDATE"
      
        User.create(:uuid => uuid, :phone_number => params[:min])
        render :text => "Welcome! All commands must be prefixed with the word 'dland'. Txt the phrase 'bo <d|s|ss>' to see if your pass is blocked out today.  Txt the word 'help' to find out more.", :status => 200 and return
        
    when "MO"
      
      chunked_message = params[:body].split(" ")
      
      case chunked_message[0].downcase
      when "bo"
        
        bo(chunked_message) and return
      
      when "time"
        
        time() and return
        
      when "help"
        
        render :text => "All commands must be prefixed with dland. \"bo <d/s/ss>\" - Is the pass specified blacked out today?. \"time\" - Opening and closing times. Enjoy.", :status => 200 and return
        
      else
        
        render :text => "Invalid Command.  Txt 'dland help' to get a list of commands.", :status => 200 and return
        
      end
      
    else
      
      render :text => "Invalid Event", :status => 200 and return
      
    end
    
    
  end
  
  protected
  
  def change_content_type
    response.headers["Content-Type"] = "text/plain"
  end
  
  def bo(chunked_message)
    return_message = ""
    
    if DisneylandParser.blackout_dates(chunked_message[1], Time.now.in_time_zone)
      return_message = "It is a blakout day today.  Sorry :("
    else
      return_message = "It is not a blackout day.  Enjoy! :)"
    end
    
    render :text => return_message, :status => 200 and return
    
  end
  
  def time()
    disney_times, ca_adventure_times = DisneylandParser.hours(Time.now.in_time_zone)
    
    render :text => "Main Park: #{disney_times}. Ca Adventures: #{ca_adventure_times}.", :status => 200 and return
  end
end
