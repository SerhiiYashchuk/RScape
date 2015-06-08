require 'test/unit'
require 'rscape/neighbor'
require 'rscape/info_sharing'

class TestInfoSharing < Test::Unit::TestCase
  def setup
    RScape::Agent.include RScape::Neighbor
    RScape::Agent.include RScape::InfoSharing
    
    @agent = RScape::Agent.new(wealth: 5, metabolism: 1, vision: 1, max_age: 25)
  end
  
  def test_creation
    assert @agent.is_a?(RScape::InfoSharing)
  end
  
  def test_sharing
    sugarscape = RScape::Sugarscape.new(rows: 3, cols: 3)
    agent1 = RScape::Agent.new(wealth: 1, metabolism: 1, vision: 1)
    agent2 = RScape::Agent.new(wealth: 2, metabolism: 2, vision: 2)
    agent3 = RScape::Agent.new(wealth: 3, metabolism: 3, vision: 3)
    agent4 = RScape::Agent.new(wealth: 4, metabolism: 4, vision: 4)
    
    @agent.move_to(1, 1)
    agent1.move_to(0, 1)
    agent2.move_to(1, 0)
    agent3.move_to(1, 2)
    agent4.move_to(2, 1)
    
    sugarscape.cell(@agent.row, @agent.col).occupant = @agent
    sugarscape.cell(agent1.row, agent1.col).occupant = agent1
    sugarscape.cell(agent2.row, agent2.col).occupant = agent2
    sugarscape.cell(agent3.row, agent3.col).occupant = agent3
    sugarscape.cell(agent4.row, agent4.col).occupant = agent4
    
    @agent.info[:greeting] = "Hello!"
    
    @agent.neighbors(sugarscape).each do |neighbor|
      @agent.share_info neighbor
      
      assert neighbor.info.include? :greeting
    end
  end
end
