module RScape
  # Represents Sugar source.
  class Sugar
    # ID for a new Sugar source.
    @@new_id = 0
    
    # Amount of sugar that source can hold.
    attr_reader :capacity
    # Current amount of sugar.
    attr_reader :level
    # Amount of sugar to increase +level+.
    attr_reader :growth
    # Row that source is placed on.
    attr_reader :row
    # Column that source is placed on.
    attr_reader :col
    # ID of the Sugar source.
    attr_reader :id
    
    # Creates a new Sugar source.
    def initialize(capacity:, level:, growth:)
      @row = nil
      @col = nil
      @capacity = capacity
      @level = level
      @growth = growth
      @id = @@new_id
      @@new_id += 1
    end
    
    # Creates new Sugar with random attributes if they are of a Range type.
    def self.random(capacity:, level:, growth:)
      capacity = rand capacity if capacity.is_a? Range
      level = rand level if level.is_a? Range
      level = capacity if level > capacity
      growth = rand growth if growth.is_a? Range
      
      Sugar.new(capacity: capacity, level: level, growth: growth)
    end
    
    # Increases current level of sugar by +growth+.
    def grow
      @level = [@level + @growth, @capacity].min
    end
    
    # Sets current level to 0.
    def empty
      @level = 0
    end
    
    # Indicates if Sugar source has any sugar.
    #
    # Returns +true+ if current level isn't equal to 0, +false+ otherwise.
    def empty?
      @level.zero?
    end
    
    # Moves Sugar source to the specified position.
    def move_to(row, col)
      @row, @col = row, col
    end
  end
end
