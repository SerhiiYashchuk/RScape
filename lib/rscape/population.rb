require_relative 'agent.rb'
require_relative 'sugarscape.rb'

module RScape
  class Population
    def initialize(sugarscape)
      @sugarscape = sugarscape
      @agents = {}
    end
    
    def add_agent(new_agent, row, col)
      row, col = @sugarscape.correct(row, col)
      destination = @sugarscape.cell(row, col)
      
      return false unless destination.occupant.nil?
      
      @agents[new_agent.id] = new_agent
      destination.occupant = new_agent
      new_agent.move_to(row, col)
      
      return true
    end
    
    def remove_agent(agent_id)
      if agent = @agents.delete(agent_id)
        @sugarscape.cell(agent.row, agent.col).occupant = nil
        agent.move_to(nil, nil)
      end
    end
    
    def agent(agent_id)
      @agents[agent_id]
    end
    
    def agents
      @agents.values
    end
    
    def move_agent_to(agent, row, col)
      destination = @sugarscape.cell(row, col)
      
      return false if !@agents.include? agent.id || !destination.occupant.nil?
      
      row, col = @sugarscape.correct(row, col)
      @sugarscape.cell(agent.row, agent.col).occupant = nil
      agent.move_to(row, col)
      destination.occupant = agent
      
      true
    end
  end
end
