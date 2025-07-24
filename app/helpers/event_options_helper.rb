module EventOptionsHelper

    def display_event_option_cost(event_option)
        return "$#{event_option.cost.to_i}" if event_option.cost > 0
        case event_option.description
          when "Stay"          then return ""
          when "Off Campus"    then return ""
          when "No, thanks"    then return ""
          else 
               return "free"
        end
    end
end
