class SiteController < ApplicationController
  
  include DisneylandHelper
  
  def index

    @user = User.new
    @user.generate_uuid
    
  end

  def txt
    
    uuid = params[:uid]
    parser = DisneylandParser.new()
    
    case params[:event]
    when "SUBSCRIPTION_UPDATE"
      
        User.create(:uuid => uuid, :phone_number => params[:min])
        render :text => "Welcome! All commands must be prefixed with the word 'dland'. Txt the phrase 'bo <d|s|ss>' to see if your pass is blocked out today.  Txt the word 'help' to find out more.", :status => 200 and return
        
    when "MO"
      
      chunked_message = params[:message].split(" ")
      
      case chunked_message[0].downcase
      when "bo"
        return_message = ""
        
        if parser.blackout_dates(chunked_message[1], Date.today)
          return_message = "It is a blakout day today.  Sorry :("
        else
          return_message = "It is not a blackout day.  Enjoy! :)"
        end
        
        render :text => return_message, :status => 200 and return

      when "help"
        
        render :text => "All commands must be prefixed with dland. 'bo <d|s|ss>' - Is the pass specified blacked out today?. 'help' - This message.  Enjoy.", :status => 200 and return
        
      else
        
        render :text => "Invalid Command.  Txt 'dland help' to get a list of commands.", :status => 404 and return
        
      end
      
    else
      
      render :text => "Invalid Event", :status => 404 and return
      
    end
    
    
  end

end
