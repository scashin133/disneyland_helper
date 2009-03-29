module DisneylandHelper
  require 'hpricot'
  require 'httparty'

  class DisneylandParser
    include HTTParty
    base_uri 'http://disneyland.disney.go.com/'
  
    PASS_TO_HTML_CLASS = {
                            :d => ["AnnualPassholderDeluxeBlockoutCalendarPage", "Deluxe"],
                            :s => ["AnnualPassholderSoCalBlockoutCalendarPage", "SouthernCalifornia"],
                            :ss => ["AnnualPassholderSoCalSelectBlockoutCalendarPage", "SouthernCaliforniaSelect"]
                         }
  
    def initialize
    
    end
  
    def blackout_dates(pass, date)
      html_class = PASS_TO_HTML_CLASS[pass.to_sym][1]
      pass = PASS_TO_HTML_CLASS[pass.to_sym][0]
      
      calendar = self.class.get("http://disneyland.disney.go.com/disneyland/en_US/ap/blockoutCalendar", :query => {:name => pass})
    
      calendar = (Hpricot(calendar)/"div.calendarGroup div.calendar")

      calendar.each do |calendar|

        if(date.strftime("%B %Y") == (calendar.at("table caption")).inner_html)

          table_cells = (calendar/"tr td")
        
          table_cells.each do |day|

            if(date.strftime("%d") == (day.at("span.dayOfMonth")).inner_html)

              if(day['class'].split(" ").include?(html_class))

                return true

              end

              return false

            end
          
          end
        
        end
      
      end    
    
    end
  
    def hours(date)
    
    end
  
  end

end