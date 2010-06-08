require 'test_helper'

class TeamTest < ActiveSupport::TestCase

  # NOTE:
  #  when testing Google Apps:
  #  1: do a .save when before minipulating fixtures
  #  2: do a .destroy on all objects that were saved

  def test_build_email
    domain = ENV['GOOGLE_DOMAIN']
    course = Course.find(:first)
    record = Team.new(:name => 'RailsFixture Team A', :course_id => course.id)
    assert_equal(record.build_email, "fall-2009-railsfixture-team-a" + "@" + domain)
  end


  def test_google_apps_create_new_and_destroy
    #Clean up from a previous execuction of a failed run of this test case
    google_apps_connection.delete_group("fall-2009-railsfixture-team-a")
  rescue GDataError => e

    course = Course.find(:first)
    record = nil #placeholder variable
    assert_difference 'count_teams', 1 do
      assert_difference 'Team.count', 1 do
        record = Team.new(:name => 'RailsFixture Team A', :course_id => course.id)
        record.save
      end
      wait_for_google_sync
    end
    assert_difference 'count_teams', -1 do
      assert_difference 'Team.count', -1 do
        record.destroy
      end
      wait_for_google_sync
    end
  end

  def test_cannot_be_same_name
    original_team = teams(:teamOne)
    original_team.save
    assert_no_difference 'count_teams' do
      assert_no_difference 'Team.count' do
        record = original_team.clone
        assert !record.save, "Should not be able to save cloned team"
      end
      wait_for_google_sync
    end
    original_team.destroy
    wait_for_google_sync
  end

  def test_rename_team
    #Clean up from a previous execuction of a failed run of this test case
    old_group = "fall-2008-fixturedeming-teamone"
    renamed_group = "fall-2008-fixturedeming-teamone_renamed"
    google_apps_connection.retrieve_all_groups.each do |list|
      group_name = list.group_id.split('@')[0]
      google_apps_connection.delete_group(old_group) if old_group == group_name
      google_apps_connection.delete_group(renamed_group) if renamed_group == group_name
    end

    team = teams(:teamOne)
    team.save
    assert_no_difference 'count_teams', 0 do
      assert_no_difference 'Team.count', 0 do
        team.update_attributes({:name => "#{team.name}_renamed"})
      end
      wait_for_google_sync
    end
    team.destroy
    wait_for_google_sync
  end

  def test_proper_email
    course = Course.find(:first)
    record = Team.new(:name => 'RailsFixture Deming Team A', :course_id => course.id)
    record.save
    expected_email = "#{course.semester}-#{course.year}-#{record.name}@#{ENV['GOOGLE_DOMAIN']}".chomp.downcase.gsub(/ /, '-')
    assert_equal record.email, expected_email, "Unexpected email value"
    record.destroy
    wait_for_google_sync
  end

  def test_change_mailinglist
    team = Team.find(:first)
    team.save
    student = users(:student_sam)
    assert_not_nil team, "team should not be nil"
    assert_not_nil student, "student should not be nil"
    #puts "DEBUG: #{team.name} consistes of #{count_members(team.build_email)} members"
    # add member
    assert_difference 'count_members(team.build_email)', 1 do
      team.add_person_by_human_name(student.human_name)
      team.save
      wait_for_google_sync
      #puts "DEBUG: #{team.name} consistes of #{count_members(team.build_email)} members"
    end
    # remove member
    assert_difference 'count_members(team.build_email)', -1 do
      team.remove_person(student.id)
      wait_for_google_sync
      #puts "DEBUG: #{team.name} consistes of #{count_members(team.build_email)} members"
    end
    #puts "DEBUG: handle bad name"
    # handle bad name
    assert_no_difference 'team.people.count' do
      team.add_person_by_human_name("abc defg")
    end
    team.destroy
    wait_for_google_sync
  end

  private
  def count_teams
    google_apps_connection.retrieve_all_groups.size
  end
  def count_members(team_email)
    google_apps_connection.retrieve_all_members(team_email).size
  end
end
