require 'test/unit'
require 'rscape/agent'

class AgentTest < Test::Unit::TestCase
  def setup
    @agent = RScape::Agent.new(wealth: 5, metabolism: 1, vision: 1, max_age: 10)
  end
  
  def test_creation
    assert_equal(@agent.wealth, 5)
    assert_equal(@agent.metabolism, 1)
    assert_equal(@agent.vision, 1)
    assert_equal(@agent.max_age, 10)
    assert_equal(@agent.age, 0)
    assert_nil @agent.row
    assert_nil @agent.col
  end
  
  def test_metabolism
    initial_wealth = @agent.wealth
    
    @agent.wealth.times do |t|
      @agent.metabolize
      
      assert_equal(@agent.wealth, initial_wealth - @agent.metabolism * (t + 1))
    end
  end
  
  def test_growth
    @agent.max_age.times do |t|
      @agent.grow
      
      assert_equal(@agent.age, t + 1)
    end
    
    assert_equal(@agent.age, @agent.max_age)
    
    @agent.grow
    
    refute_equal(@agent.age, @agent.max_age + 1)
  end
  
  def test_movement
    3.times do |row|
      2.times do |col|
        @agent.move_to(row, col)
        
        assert_equal(@agent.row, row)
        assert_equal(@agent.col, col)
      end
    end
  end
end
