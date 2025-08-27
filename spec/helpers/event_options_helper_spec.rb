# filepath: /mnt/c/Dev/EventSC/spec/helpers/event_options_helper_spec.rb
require 'rails_helper'

RSpec.describe EventOptionsHelper, type: :helper do
  describe '#display_event_option_cost' do
    let(:event_option) { double('EventOption') }

    it 'returns an empty string for "Stay"' do
      allow(event_option).to receive(:description).and_return("Stay")
      allow(event_option).to receive(:cost).and_return(0)
      expect(helper.display_event_option_cost(event_option)).to eq("")
    end

    it 'returns an empty string for "Off Campus"' do
      allow(event_option).to receive(:description).and_return("Off Campus")
      allow(event_option).to receive(:cost).and_return(0)
      expect(helper.display_event_option_cost(event_option)).to eq("")
    end

    it 'returns "(free)" for a cost of 0' do
      allow(event_option).to receive(:description).and_return("Some Option")
      allow(event_option).to receive(:cost).and_return(0)
      expect(helper.display_event_option_cost(event_option)).to eq("(free)")
    end

    it 'returns the cost for other options' do
      allow(event_option).to receive(:description).and_return("Some Option")
      allow(event_option).to receive(:cost).and_return(25)
      expect(helper.display_event_option_cost(event_option)).to eq("(Cost: $25)")
    end
  end
end
