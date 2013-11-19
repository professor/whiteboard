class UpdateOldGradingRuleValues < ActiveRecord::Migration
  def self.up
    puts "Updating old values of grading rules......"
    GradingRule.update_all({ :A_grade_min => 94.0 }, { :A_grade_min => nil })
    GradingRule.update_all({ :A_minus_grade_min => 90.0 }, { :A_minus_grade_min => nil })
    GradingRule.update_all({ :B_plus_grade_min => 87.0 }, { :B_plus_grade_min => nil })
    GradingRule.update_all({ :B_grade_min => 83.0 }, { :B_grade_min => nil })
    GradingRule.update_all({ :B_minus_grade_min => 80.0 }, { :B_minus_grade_min => nil })
    GradingRule.update_all({ :C_plus_grade_min => 78.0 }, { :C_plus_grade_min => nil })
    GradingRule.update_all({ :C_grade_min => 74.0 }, { :C_grade_min => nil })
    GradingRule.update_all({ :C_minus_grade_min =>  70.0 }, { :C_minus_grade_min => nil })
    puts "Values updated successfully......"
  end

  def self.down
  end
end
