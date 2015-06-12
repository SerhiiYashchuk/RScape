require_relative 'neighbor.rb'

module RScape
  # Represents Information sharing behavior for Agent.
  module InfoSharing
    # Information.
    def info
      @info ||= {}
    end
    
    # Merges +agent+s' information with its own.
    def share_info(agent)
      agent.info.merge! self.info
    end
  end
end
