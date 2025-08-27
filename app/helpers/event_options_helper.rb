module EventOptionsHelper
    def display_event_option_cost(event_option)
        return "$#{event_option.cost.to_i}" if event_option.cost > 0
        case event_option.description
        when "Stay"          then ""
        when "Off Campus"    then ""
        when "No, thanks"    then ""
        else
               "free"
        end
    end
end
