require_relative 'model.rb'
require_relative 'simulation_preset.rb'
require 'rscape/harvester'
require 'rscape/neighbor'
require 'rscape/info_sharing'

def free_pos_in_fov(agent)
  distance = rand 1..agent.vision
  direction = nil
  
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
  
  [new_row, new_col]
end

def move_agent(agent, sugarscape, row, col)
  sugarscape.cell(agent.row, agent.col).occupant = nil
  agent.move_to(row, col)
  sugarscape.place_agent agent
end

$LOGGING = ARGV.include?("--logging") || ARGV.include?("-l")

# Log colors
GATHERING_COLOR = '#003300'
INFO_SHARING_COLOR = '#000033'
DEATH_COLOR = '#990000'

# Model params
$ROWS_NUMBER ||= 0
$COLUMNS_NUMBER ||= 0
$AGENTS_NUMBER ||= 0
$SUGARS_NUMBER ||= 0
$AGENT_INITIAL_WEALTH ||= 0
$AGENT_METABOLISM ||= 0
$AGENT_VISION ||= 0
$AGENT_MAX_AGE ||= 0
$SUGAR_CAPACITY ||= 0
$SUGAR_LEVEL ||= 0
$SUGAR_GROWTH ||= 0
$INFO_CHUNKS ||= []
$INITIAL_INFO_BEARERS ||= 0

app = Qt::Application.new ARGV
mw = Model.new

mw.tps = 3
mw.sugarscape_params.rows = $ROWS_NUMBER
mw.sugarscape_params.cols = $COLUMNS_NUMBER
mw.sugarscape_params.agents_count = $AGENTS_NUMBER
mw.sugarscape_params.sugar_count = $SUGARS_NUMBER
mw.sugar_params.capacity = $SUGAR_CAPACITY
mw.sugar_params.level = $SUGAR_LEVEL
mw.sugar_params.growth = $SUGAR_GROWTH
mw.agent_params.wealth = $AGENT_INITIAL_WEALTH
mw.agent_params.metabolism = $AGENT_METABOLISM
mw.agent_params.vision = $AGENT_VISION
mw.agent_params.max_age = $AGENT_MAX_AGE
mw.info_params.chunks = $INFO_CHUNKS.map(&:to_s)
mw.info_params.initial_bearers = $INITIAL_INFO_BEARERS

mw.log.hide unless $LOGGING

# Setup Agent's behavior patterns
RScape::Agent.include RScape::Harvester
RScape::Agent.include RScape::Neighbor
RScape::Agent.include RScape::InfoSharing

# Procedures
mw.set_agent_creation_proc do
  RScape::Agent.random(wealth: mw.agent_params.wealth,
                       metabolism: mw.agent_params.metabolism,
                       vision: mw.agent_params.vision,
                       max_age: mw.agent_params.max_age)
end

mw.set_sugar_creation_proc do
  RScape::Sugar.random(capacity: mw.sugar_params.capacity,
                       level: mw.sugar_params.level,
                       growth: mw.sugar_params.growth)
end

mw.set_agent_placement_proc do
  row, col = nil, nil
  
  while true
    row = rand mw.sugarscape.rows_count
    col = rand mw.sugarscape.cols_count
    
    break unless mw.sugarscape.cell(row, col).occupied?
  end
  
  [row, col]
end

mw.set_sugar_placement_proc do
  row, col = nil, nil
  
  while true
    row = rand mw.sugarscape.rows_count
    col = rand mw.sugarscape.cols_count
    
    break unless mw.sugarscape.cell(row, col).has_sugar?
  end
  
  [row, col]
end

mw.set_info_placement_proc do |agent|
  if agent.id % ((mw.population.size - 1) / $INITIAL_INFO_BEARERS) == 0
    agent.info = $INFO_CHUNKS
    mw.view.change_agent_color(agent.id, 0, 0, 255)
  end
end

mw.set_iteration_proc do
  if $LOGGING
    mw.log.add "<b>Iteration #{mw.iterations_passed}</b>"
  end
  
  agents_to_delete = []
  agents_to_replace = []
  
  mw.population.each_with_index do |agent, index|
    if $LOGGING
      mw.log.add "<i>A:#{agent.id}</i> age is #{agent.age}"
      mw.log.add "<i>A:#{agent.id}</i> wealth is #{agent.wealth}"
    end
    
    # Search for some sugar
    sugars = agent.find_free_sugar mw.sugarscape
    
    if sugars.empty?
      # Move in random direction
      3.times do
        new_row, new_col = free_pos_in_fov agent
        
        if !mw.sugarscape.cell(new_row, new_col).occupied?
          if $LOGGING
            mw.log.add "<i>A:#{agent.id}</i> moved from [#{agent.row}, " \
              "#{agent.col}] to [#{new_row}, #{new_col}]"
          end
          
          move_agent(agent, mw.sugarscape, new_row, new_col)
          mw.view.move_agent(agent.id, agent.row, agent.col)
          
          break
        end
      end
      
    else
      # Gather sugar
      best_sugar = sugars.max_by(&:level)
      sugar_level = best_sugar.level
      
      if $LOGGING
        mw.log.add "<i>A:#{agent.id}</i> moved from [#{agent.row}, " \
          "#{agent.col}] to [#{best_sugar.row}, #{best_sugar.col}]"
      end
      
      move_agent(agent, mw.sugarscape, best_sugar.row, best_sugar.col)
      mw.view.move_agent(agent.id, agent.row, agent.col)
      agent.gather best_sugar
      
      if $LOGGING
        mw.log.add("<i>A:#{agent.id}</i> gathered #{sugar_level} points of " \
                   "sugar from <i>S:#{best_sugar.id}</i>",
                   color: GATHERING_COLOR)
      end
    end
    
    # Share Info
    if !agent.info.empty?
      agent.neighbors(mw.sugarscape).each do |neighbor|
        agent.share_info neighbor
        mw.view.change_agent_color(neighbor.id, 0, 0, 255)
        
        if $LOGGING
          mw.log.add("<i>A:#{agent.id}</i> shared info with " \
                     "<i>A:#{neighbor.id}</i>", color: INFO_SHARING_COLOR)
          mw.log.add "<i>A:#{agent.id}</i> info is <i>#{agent.info}</i>"
        end
      end
    end
    
    agent.metabolize
    agent.grow
    
    # Mark dead agents to be removed
    if agent.wealth.zero?
      agents_to_delete << agent
      
      if $LOGGING
        mw.log.add("<i>A:#{agent.id}</i> died because of starvation",
                   color: DEATH_COLOR)
      end
    end
    
    # Mark old agents to be replaced
    if agent.age == agent.max_age && !agents_to_delete.include?(index)
      agents_to_replace << index
      
      if $LOGGING
        mw.log.add("<i>A:#{agent.id}</i> died because of age",
                   color: DEATH_COLOR)
      end
    end
  end
  
  # Produce sugar
  mw.sugarscape.growback
  
  # Replace old agents
  agents_to_replace.each do |index|
    agent = mw.population[index]
    
    mw.sugarscape.cell(agent.row, agent.col).occupant = nil
    mw.view.delete_agent agent.id
    
    new_agent = mw.new_agent_proc.call
    row, col = mw.agent_placement_proc.call
    
    mw.info_placement_proc.call new_agent
    new_agent.move_to(row, col)
    mw.sugarscape.place_agent new_agent
    mw.population[index] = new_agent
    mw.view.add_agent new_agent
  end
  
  # Delete dead agents
  agents_to_delete.each do |agent|
    mw.sugarscape.cell(agent.row, agent.col).occupant = nil
    mw.view.delete_agent agent.id
    mw.population.delete agent
  end
  
  mw.update_statistic
  mw.collect_statistic
  
  if $LOGGING
    mw.log.add ''
  end
end

mw.setWindowTitle "Sugarscape"
mw.show
app.exec
