require 'test/unit'
require 'rscape/sugarscape'

class TestSugarscape < Test::Unit::TestCase
  def setup
    @sugarscape = RScape::Sugarscape.new(rows: 5, cols: 5)
  end
  
  def test_creation
    assert_equal(@sugarscape.rows_count, 5)
    assert_equal(@sugarscape.cols_count, 5)
  end
  
  def test_sugar
    sugar1 = RScape::Sugar.new(capacity: 5, level: 2, growth: 1)
    sugar2 = RScape::Sugar.new(capacity: 8, level: 0, growth: 2)
    
    sugar1.move_to(0, 0)
    sugar2.move_to(3, 3)
    
    assert @sugarscape.add_sugar(sugar1)
    assert @sugarscape.add_sugar(sugar2)
    assert_equal(@sugarscape.cell(sugar1.row, sugar1.col).sugar, sugar1)
    assert_equal(@sugarscape.cell(sugar2.row, sugar2.col).sugar, sugar2)
    refute_empty @sugarscape.sugars
    
    initial_level1 = sugar1.level
    initial_level2 = sugar2.level
    
    @sugarscape.growback
    
    assert_equal(sugar1.level, initial_level1 + sugar1.growth)
    assert_equal(sugar2.level, initial_level2 + sugar2.growth)
    
    @sugarscape.remove_sugar sugar1.id
    @sugarscape.remove_sugar sugar2.id
    
    assert_nil @sugarscape.cell(sugar1.row, sugar1.col).sugar
    assert_nil @sugarscape.cell(sugar2.row, sugar2.col).sugar
    assert_empty @sugarscape.sugars
  end
  
  def test_cell_correction
    assert_equal(@sugarscape.cell(0, 0), @sugarscape.cell(
                 @sugarscape.rows_count, @sugarscape.cols_count))
    assert_equal(@sugarscape.cell(1, 1), @sugarscape.cell(
                 @sugarscape.rows_count + 1, @sugarscape.cols_count + 1))
  end
end
