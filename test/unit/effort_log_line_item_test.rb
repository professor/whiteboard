require 'test_helper'

class EffortLogLineItemTest < ActiveSupport::TestCase

  def test_positive_numbers_are_valid
    line = EffortLogLineItem.new()
    line.day1 = 3
    assert_valid line
  end

  def test_negative_numbers_are_invalid
    line = EffortLogLineItem.new()
    line.day1 = -3
    assert !line.valid?
  end

  def test_non_numbers_are_invalid
    line = EffortLogLineItem.new()
    line.day1 = 'A'
    assert !line.valid?
  end

  def test_blanks_are_valid
    line = EffortLogLineItem.new()
    line.day1 = ''
    assert_valid line
    line.day1 = nil
    assert_valid line
  end
  
end
