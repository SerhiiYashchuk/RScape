require_relative 'sugar.rb'
require_relative 'cell.rb'

module RScape
  # Represents an area where all action takes place =).
  class Sugarscape
    # Number of rows.
    attr_reader :rows_count
    # Number of columns.
    attr_reader :cols_count
    
    # Creates a new Sugarscape of the specified size.
    def initialize(rows:, cols:)
      @rows_count = rows
      @cols_count = cols
      @cells = Array.new(rows) { Array.new(cols) { Cell.new } }
      @sugar_sources = {}
    end
    
    # Returns a Cell that is located on a specified position.
    def cell(row, col)
      row, col = correct(row, col)
      @cells[row][col]
    end
    
    # Number of Cells.
    def cells_count
      @rows_count * @cols_count
    end
    
    # Adds Sugar source.
    #
    # new_sugar - Sugar source to be placed. Has to be positioned previously.
    #
    # Returns +true+ if succeeded, +false+ if +new_sugar+ isn't positioned
    # or its position is already taken.
    def add_sugar(new_sugar)
      return false if new_sugar.row.nil? || new_sugar.col.nil?
      
      row, col = correct(new_sugar.row, new_sugar.col)
      destination = @cells[row][col]
      
      return false if destination.has_sugar?
      
      @sugar_sources[new_sugar.id] = new_sugar
      destination.sugar = new_sugar
      
      return true
    end
    
    # Removes Sugar source.
    #
    # sugar_id - ID of the Sugar source.
    def remove_sugar(sugar_id)
      if sugar = @sugar_sources.delete(sugar_id)
        cell(sugar.row, sugar.col).sugar = nil
      end
    end
    
    # Returns Sugar source with the given ID.
    def sugar(sugar_id)
      @sugar_sources[sugar_id]
    end
    
    # Returns an Array of Sugar sources.
    def sugars
      @sugar_sources.values
    end
    
    # Increases level of sugar for all Sugar sources.
    def growback
      @sugar_sources.each_value(&:grow)
    end
    
    # Places Agent.
    #
    # agent - Agent to place. Has to be positioned previously.
    #
    # Returns +true+ if succeeded, +false+ if Agent isn't positioned or its
    # position is already taken.
    def place_agent(agent)
      return false if agent.row.nil? || agent.col.nil?
      
      row, col = correct(agent.row, agent.col)
      destination = @cells[row][col]
      
      return false if destination.occupied?
      
      destination.occupant = agent
      
      return true
    end
    
    # Spreads pollution.
    # def diffuse_pollution
    #   pollution_grid = []
      
    #   @cells.each do |row|
    #     pollution_grid << row.collect(&:pollution)
    #   end
      
    #   @rows_count.times do |row|
    #     @cols_count.times do |col|
    #       top = correct(row - 1, col)
    #       bottom = correct(row + 1, col)
    #       left = correct(row, col - 1)
    #       right = correct(row, col + 1)
          
    #       total_pollution = @cells[row][col].pollution
    #       total_pollution += pollution_grid[top[0]][top[1]]
    #       total_pollution += pollution_grid[bottom[0]][bottom[1]]
    #       total_pollution += pollution_grid[left[0]][left[1]]
    #       total_pollution += pollution_grid[right[0]][right[1]]
          
    #       @cells[row][col].pollution = total_pollution.to_f / 5
    #     end
    #   end
    # end
    
    # Returns correct Cell on a specified position.
    def correct(row, col)
      if row.between?(0, @rows_count - 1) && col.between?(0, @cols_count - 1)
        [row, col]
      end
      
      row = row % @rows_count
      col = col % @cols_count
      row += @rows_count if row < 0
      col += @cols_count if col < 0
      
      [row, col]
    end
  end
end
