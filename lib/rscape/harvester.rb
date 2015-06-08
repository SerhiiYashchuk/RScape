require_relative 'sugarscape.rb'

module RScape
  module Harvester
    def gather(sugar)
      @wealth += sugar.level
      sugar.empty
    end
    
    def find_free_sugar(sugarscape)
      found_sugar = []
      
      @vision.times do |v|
        v += 1
        
        field_of_view = [
          [@row, @col - v],
          [@row, @col + v],
          [@row - v, @col],
          [@row + v, @col]
        ]
        
        field_of_view.each do |site|
          destination = sugarscape.cell(site[0], site[1])
          
          if destination.has_sugar? && !destination.occupied?
            found_sugar << destination.sugar
          end
        end
      end
      
      found_sugar
    end
  end
end
