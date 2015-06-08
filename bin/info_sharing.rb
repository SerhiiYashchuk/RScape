require 'rscape/sugarscape'
require 'rscape/agent'
require 'rscape/harvester'
require 'rscape/info_sharing'

RScape::Agent.include RScape::Harvester
RScape::Agent.include RScape::Neighbor
RScape::Agent.include RScape::InfoSharing

sugarscape = RScape::Sugarscape.new(rows: 10, cols: 10)
sugars = Array.new(40) { RScape::Sugar.new(capacity: 6, level: 6, growth: 1) }
population = Array.new(30) { RScape::Agent.random(wealth: 6..10,
  metabolism: 1..3, vision: 1..2, max_age: nil) }

sugars.each do |sugar|
  row = rand sugarscape.rows_count
  col = rand sugarscape.cols_count
  
  sugar.move_to(row, col)
  redo unless sugarscape.add_sugar sugar
end

population.each do |agent|
  row = rand sugarscape.rows_count
  col = rand sugarscape.cols_count
  
  redo if sugarscape.cell(row, col).occupied?
  
  agent.move_to(row, col)
  sugarscape.cell(row, col).occupant = agent
end

population.each do |agent|
  if agent.id % 10 == 0
    agent.info[:greeting] = "Hello!"
  end
end

10.times do |iteration|
  if $DEBUG
    puts "Iteration #{iteration}"
  end
  
  agents_to_delete = []
  agents_to_replace = []
  
  population.each_with_index do |agent, index|
    # Search for some sugar
    sugars = agent.find_free_sugar sugarscape
    
    if sugars.empty?
      # Move in random direction
      distance = rand 1..agent.vision
      direction = []
      
      case rand 1..4
      when 1
        direction = [0, -1] # top
      when 2
        direction = [0, 1] # bottom
      when 3
        direction = [-1, 0] # left
      when 4
        direction = [1, 0] # right
      end
      
      new_row = agent.row + direction[0] * distance
      new_col = agent.col + direction[1] * distance
      
      if $DEBUG
        puts "A:#{agent.id} moved from [#{agent.row}, #{agent.col}] " \
        "to [#{new_row}, #{new_col}]"
      end
      
      sugarscape.cell(agent.row, agent.col).occupant = nil
      agent.move_to(new_row, new_col)
      sugarscape.cell(agent.row, agent.col).occupant = agent
      
    else
      # Gather sugar
      best_sugar = sugars.max_by(&:level)
      
      if $DEBUG
        puts "A:#{agent.id} moved from [#{agent.row}, #{agent.col}] " \
        "to [#{best_sugar.row}, #{best_sugar.col}]"
      end
      
      sugarscape.cell(agent.row, agent.col).occupant = nil
      agent.move_to(best_sugar.row, best_sugar.col)
      sugarscape.cell(agent.row, agent.col).occupant = agent
      agent.gather best_sugar
      
      if $DEBUG
        puts "A:#{agent.id} gathered #{best_sugar.level} points of sugar " \
        "from S:#{best_sugar.id}"
      end
    end
    
    # Share Info
    agent.neighbors(sugarscape).each do |neighbor|
      if !agent.info.empty?
        agent.share_info neighbor
        
        if $DEBUG
          puts "A:#{agent.id} shared info with A:#{neighbor.id}"
          puts "A:#{agent.id} info is #{agent.info}"
        end
      end
    end
    
    # Mark dead agents to be removed
    if agent.wealth.zero?
      agents_to_delete << index
      sugarscape.cell(agent.row, agent.col).occupant = nil
      
      if $DEBUG
        puts "A:#{agent.id} died because of starvation"
      end
    end
    
    # Mark old agents to be replaced
    if agent.age == agent.max_age
      agents_to_replace << index
      
      if $DEBUG
        puts "A:#{agent.id} died because of age"
      end
    end
    
    agent.metabolize
    agent.grow
    
    if $DEBUG
      puts "A:#{agent.id} age is #{agent.age}"
      puts "A:#{agent.id} wealth is #{agent.wealth}"
    end
  end
  
  # Produce sugar
  sugarscape.growback
  
  # Replace old agents
  agents_to_replace.each do |index|
    row = rand sugarscape.rows_count
    col = rand sugarscape.cols_count
    
    redo if sugarscape.cell(row, col).occupied?
    
    new_agent = RScape::Agent.random(wealth: 6..10, metabolism: 1..3,
                                     vision: 1..2, max_age: 20..30)
    
    new_agent.move_to(row, col)
    sugarscape.cell(new_agent.row, new_agent.col).occupant = new_agent
    population[index] = new_agent
  end
  
  # Delete dead agents
  agents_to_delete.each { |index| population.delete_at index }
  
  # Info statistic
  smart_agents = 0
  
  population.each do |agent|
    smart_agents += 1 unless agent.info.empty?
  end
  
  puts "Info percentage: #{smart_agents.to_f / population.size}"
end
