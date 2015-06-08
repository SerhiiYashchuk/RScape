module RScape
  class Agent
    @@new_id = 0
    
    attr_reader :wealth, :vision, :metabolism, :row, :col, :age, :max_age, :id,
      :initial_wealth
    
    def initialize(wealth:, metabolism:, vision:, max_age: nil)
      @row = nil
      @col = nil
      @wealth = @initial_wealth = wealth
      @metabolism = metabolism
      @vision = vision
      @age = 0
      @max_age = max_age
      @id = @@new_id
      @@new_id += 1
    end
    
    def self.random(wealth:, metabolism:, vision:, max_age: nil)
      wealth = rand wealth if wealth.is_a? Range
      metabolism = rand metabolism if metabolism.is_a? Range
      vision = rand vision if vision.is_a? Range
      max_age = rand max_age if max_age.is_a? Range
      
      Agent.new(wealth: wealth, metabolism: metabolism, vision: vision,
                max_age: max_age)
    end
    
    def metabolize
      @wealth = [@wealth - @metabolism, 0].max
    end
    
    def grow
      if @max_age.nil?
        @age += 1
        
      else
        @age += 1 if @age < @max_age
      end
    end
    
    def move_to(row, col)
      @row, @col = row, col
    end
  end
end
