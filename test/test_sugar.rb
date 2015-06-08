require 'test/unit'
require 'rscape/sugar'

class TestSugar < Test::Unit::TestCase
  def setup
    @sugar = RScape::Sugar.new(capacity: 5, level: 0, growth: 1)
  end
  
  def test_creation
    assert_equal(@sugar.capacity, 5)
    assert_equal(@sugar.level, 0)
    assert_equal(@sugar.growth, 1)
  end
  
  def test_growth
    @sugar.capacity.times do |t|
      @sugar.grow
      
      assert_equal(@sugar.level, t + 1)
    end
    
    @sugar.grow
    
    refute_equal(@sugar.level, @sugar.capacity + 1)
    refute @sugar.empty?
    
    @sugar.empty
    
    assert_equal(@sugar.level, 0)
    assert @sugar.empty?
  end
  
  def test_movement
    3.times do |row|
      2.times do |col|
        @sugar.move_to(row, col)
        
        assert_equal(@sugar.row, row)
        assert_equal(@sugar.col, col)
      end
    end
  end
end
