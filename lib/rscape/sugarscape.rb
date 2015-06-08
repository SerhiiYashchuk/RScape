require_relative 'sugar.rb'
require_relative 'cell.rb'

module RScape
  class Sugarscape
    attr_reader :rows_count, :cols_count
    
    def initialize(rows:, cols:)
      @rows_count = rows
      @cols_count = cols
      @cells = Array.new(rows) { Array.new(cols) { Cell.new } }
      @sugar_sources = {}
    end
    
    def cell(row, col)
      row, col = correct(row, col)
      @cells[row][col]
    end
    
    def cells_count
      @rows_count * @cols_count
    end
    
    def add_sugar(new_sugar)
      return false if new_sugar.row.nil? || new_sugar.col.nil?
      
      row, col = correct(new_sugar.row, new_sugar.col)
      destination = @cells[row][col]
      
      return false if destination.has_sugar?
      
      @sugar_sources[new_sugar.id] = new_sugar
      destination.sugar = new_sugar
      
      return true
    end
    
    def remove_sugar(sugar_id)
      if sugar = @sugar_sources.delete(sugar_id)
        cell(sugar.row, sugar.col).sugar = nil
      end
    end
    
    def sugar(sugar_id)
      @sugar_sources[sugar_id]
    end
    
    def sugars
      @sugar_sources.values
    end
    
    def growback
      @sugar_sources.each_value(&:grow)
    end
    
    def place_agent(agent)
      return false if agent.row.nil? || agent.col.nil?
      
      row, col = correct(agent.row, agent.col)
      destination = @cells[row][col]
      
      return false if destination.occupied?
      
      destination.occupant = agent
      
      return true
    end
    
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
