require_relative 'neighbor.rb'

module RScape
  module InfoSharing
    def info
      @info ||= {}
    end
    
    def share_info(agent)
      agent.info.merge! self.info
    end
  end
end
