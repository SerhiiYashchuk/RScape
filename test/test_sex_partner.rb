require 'test/unit'
require 'rscape/agent'
require 'rscape/sex_partner'

$MIN_CHILDBEARING_AGE = 0
$MAX_CHILDBEARING_AGE = 5

class TestSexPartner < Test::Unit::TestCase
  def setup
    RScape::Agent.include RScape::SexPartner
    
    @male_agent = RScape::Agent.new(wealth: 6, metabolism: 1, vision: 2)
    @female_agent = RScape::Agent.new(wealth: 8, metabolism: 2, vision: 1)
    
    @male_agent.sex = :male
    @female_agent.sex = :female
  end
  
  def test_creation
    assert @male_agent.is_a?(RScape::SexPartner)
    assert @female_agent.is_a?(RScape::SexPartner)
    assert @male_agent.fertile?
    assert @female_agent.fertile?
  end
  
  def test_birth
    child_agent = @female_agent.birth_child_with @male_agent
    
    assert_equal(child_agent.wealth,
                 (@male_agent.initial_wealth + @female_agent.initial_wealth) / 2)
    refute_nil child_agent.sex
  end
end
