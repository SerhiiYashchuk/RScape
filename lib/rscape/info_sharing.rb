require_relative 'neighbor.rb'

module RScape
  # Represents Information sharing behavior for Agent.
  module InfoSharing
    # Information getter.
    def info
      @info ||= []
    end
    
    # Information setter.
    def info=(value)
      @info = value
    end
    
    # Merges +agent+s' information with its own.
    def share_info(agent)
      agent.info += self.info - agent.info
    end
  end
end
