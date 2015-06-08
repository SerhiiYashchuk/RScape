module RScape
  class Sugar
    @@new_id = 0
    
    attr_reader :capacity, :level, :growth, :row, :col, :id
    
    def initialize(capacity:, level:, growth:)
      @row = nil
      @col = nil
      @capacity = capacity
      @level = level
      @growth = growth
      @id = @@new_id
      @@new_id += 1
    end
    
    def self.random(capacity:, level:, growth:)
      capacity = rand capacity if capacity.is_a? Range
      level = rand level if level.is_a? Range
      level = capacity if level > capacity
      growth = rand growth if growth.is_a? Range
      
      Sugar.new(capacity: capacity, level: level, growth: growth)
    end
    
    def grow
      @level = [@level + @growth, @capacity].min
    end
    
    def empty
      @level = 0
    end
    
    def empty?
      @level.zero?
    end
    
    def move_to(row, col)
      @row, @col = row, col
    end
  end
end
