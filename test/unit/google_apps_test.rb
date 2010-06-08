require 'test_helper'

class GoogleAppsTest < ActiveSupport::TestCase

  def test_switch_west_to_sv
    assert_equal switch_sv_to_west("andrew.carnegie@sv.cmu.edu"), "andrew.carnegie@west.cmu.edu"
    assert_equal switch_sv_to_west("andrew.carnegie@west.cmu.edu"), "andrew.carnegie@west.cmu.edu"
    assert_equal switch_sv_to_west("andrew.carnegie@sandbox.sv.cmu.edu"), "andrew.carnegie@sandbox.sv.cmu.edu"
    assert_equal switch_sv_to_west("andrew.carnegie@andrew.cmu.edu"), "andrew.carnegie@andrew.cmu.edu"
    assert_equal switch_sv_to_west("randomness"), "randomness"
    assert_equal switch_sv_to_west(""), ""
    assert_equal switch_sv_to_west(nil), nil

    assert_equal switch_west_to_sv("andrew.carnegie@sv.cmu.edu"), "andrew.carnegie@sv.cmu.edu"
    assert_equal switch_west_to_sv("andrew.carnegie@west.cmu.edu"), "andrew.carnegie@sv.cmu.edu"
    assert_equal switch_west_to_sv("andrew.carnegie@andrew.cmu.edu"), "andrew.carnegie@andrew.cmu.edu"
    assert_equal switch_west_to_sv("andrew.carnegie@sandbox.sv.cmu.edu"), "andrew.carnegie@sandbox.sv.cmu.edu"
    assert_equal switch_west_to_sv("randomness"), "randomness"
    assert_equal switch_west_to_sv(""), ""
    assert_equal switch_west_to_sv(nil), nil
  end


end
