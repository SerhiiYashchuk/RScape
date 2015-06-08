require 'test/unit'
require 'rscape/cell'

class TestCell < Test::Unit::TestCase
  def test_creation
    cell = RScape::Cell.new
    
    assert_nil cell.sugar
    assert_nil cell.occupant
    assert_equal(cell.pollution, 0.0)
    refute cell.has_sugar?
    refute cell.occupied?
  end
end
