require 'test_helper'

class TimeMachineTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    now_as('2009-10-26') do
      assert_equal(Date.today, Date.new(2009,10,26))
      assert Date.today.cwday == 1 # assert that 2009-10-26 is a Monday      
    end
    
    now_as('2009-11-01') do
      assert_equal(Date.today, Date.new(2009,11,1))
      assert Date.today.cwday == 7 # assert that 2009-11-01 is Sunday
      
      #test nested date overrides 
      now_as('2009-11-02') do
        assert_equal(Date.today, Date.new(2009,11,2))
        assert Date.today.cwday == 1 # assert that 2009-11-02 is Monday        
      end
    end
    
  end
end
