module RScape
  # Represents Agent.
  class Agent
    # ID for a new Agent.
    @@new_id = 0
    
    # Current amount of sugar.
    attr_reader :wealth
    # Number of cells that Agent can see from its current position.
    attr_reader :vision
    # Amount of sugar that Agent needs for one iteration of its life.
    attr_reader :metabolism
    # Row that Agent stands on.
    attr_reader :row
    # Column that Agent stands on.
    attr_reader :col
    # Number of iteration that Agent lived for.
    attr_reader :age
    # Number of iteration that Agent can live for.
    attr_reader :max_age
    # ID of the Agent.
    attr_reader :id
    # Initial amount of sugar.
    attr_reader :initial_wealth
    
    # Creates new Agent.
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
    
    # Creates new Agent with random attributes if they are of a Range type.
    def self.random(wealth:, metabolism:, vision:, max_age: nil)
      wealth = rand wealth if wealth.is_a? Range
      metabolism = rand metabolism if metabolism.is_a? Range
      vision = rand vision if vision.is_a? Range
      max_age = rand max_age if max_age.is_a? Range
      
      Agent.new(wealth: wealth, metabolism: metabolism, vision: vision,
                max_age: max_age)
    end
    
    # Decreases +wealth+ by +metabolism+.
    def metabolize
      @wealth = [@wealth - @metabolism, 0].max
    end
    
    # Increases +age+ by 1 until it reaches +max_age+.
    def grow
      if @max_age.nil?
        @age += 1
        
      else
        @age += 1 if @age < @max_age
      end
    end
    
    # Moves Agent to the specified position.
    def move_to(row, col)
      @row, @col = row, col
    end
  end
end
