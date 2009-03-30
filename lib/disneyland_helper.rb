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
    
    def self.blackout_dates(pass, date)
      html_class = PASS_TO_HTML_CLASS[pass.to_sym][1]
      pass = PASS_TO_HTML_CLASS[pass.to_sym][0]
      
      calendar = get("/disneyland/en_US/ap/blockoutCalendar", :query => {:name => pass})
    
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
  
    def self.hours(date)

      hours = get("/disneyland/en_US/calendar/viewSchedule", :query => {
        :arrivalDate =>	date.day,
        :arrivalMonth =>	date.month,
        :arrivalYear =>	date.year,
        :checkDCA =>	"on",
        :checkDLP =>	"on",
        :lengthOfStay =>	1,
        :"roll_CalendarGetScheduleBtnMedia_en_US.x" =>	46,
        :"roll_CalendarGetScheduleBtnMedia_en_US.y" =>	8
      })
      
      hours = Hpricot(hours)
      
      hours = (hours/'div#column2 div.sched div.schedParkHeader'/'++div.schedContent')
      main_park = (hours[0]/"div:last-of-type").inner_html
      ca_adventure = (hours[1]/"div:last-of-type").inner_html
      
      return main_park, ca_adventure
      
    end
  
  end

end