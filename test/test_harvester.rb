require 'test/unit'
require 'rscape/agent'
require 'rscape/harvester'

class TestHarvester < Test::Unit::TestCase
  def setup
    RScape::Agent.include RScape::Harvester
    
    @agent = RScape::Agent.new(wealth: 5, metabolism: 1, vision: 1, max_age: 25)
  end
  
  def test_creation
    assert @agent.is_a?(RScape::Harvester)
  end
  
  def test_sugar_search
    sugarscape = RScape::Sugarscape.new(rows: 3, cols: 3)
    sugar1 = RScape::Sugar.new(capacity: 1, level: 1, growth: 1)
    sugar2 = RScape::Sugar.new(capacity: 2, level: 2, growth: 2)
    sugar3 = RScape::Sugar.new(capacity: 3, level: 3, growth: 3)
    sugar4 = RScape::Sugar.new(capacity: 4, level: 4, growth: 4)
    
    sugar1.move_to(0, 1)
    sugar2.move_to(1, 0)
    sugar3.move_to(1, 2)
    sugar4.move_to(2, 1)
    
    sugarscape.add_sugar sugar1
    sugarscape.add_sugar sugar2
    sugarscape.add_sugar sugar3
    sugarscape.add_sugar sugar4
    
    sugarscape.cell(sugar2.row, sugar2.col).occupant = "Occupant"
    sugarscape.cell(sugar3.row, sugar3.col).occupant = "Occupant"
    
    @agent.move_to(1, 1)
    
    found_sugars = @agent.find_free_sugar sugarscape
    
    assert found_sugars.include?(sugar1)
    assert found_sugars.include?(sugar4)
    refute found_sugars.include?(sugar2)
    refute found_sugars.include?(sugar3)
  end
  
  def test_sugar_gathering
    sugar = RScape::Sugar.new(capacity: 10, level: 4, growth: 2)
    initial_wealth = @agent.wealth
    sugar_level = sugar.level
    
    @agent.gather sugar
    
    assert_equal(@agent.wealth, initial_wealth + sugar_level)
    assert sugar.empty?
  end
end
