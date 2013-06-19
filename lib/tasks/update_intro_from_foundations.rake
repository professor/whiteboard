require 'rubygems'
require 'rake'
require 'rails'

  def update_ise_from_fse(url)
    intro_course = Course.find_by_name("Introduction to Software Engineering")

    foundations_page = Page.find_by_url(url)
    if foundations_page.nil?
      return false
    end    
    
    intro_url = url.gsub("fse", "ise")
    intro_page = Page.find_by_url(intro_url)

    if intro_page.nil?
      puts "--Create a new page"
      # intro_page = foundations_page.dup #dup isn't working quite right for 3.0.9
      intro_page = Page.new(foundations_page.attributes)
    else
      puts "--Copy from existing page"
      intro_id = intro_page.id
      intro_page.attributes = foundations_page.attributes
      intro_page.id = intro_id
    end
    intro_page.course_id = intro_course.id
    intro_page.url = intro_url
    intro_page.tab_one_contents = intro_page.tab_one_contents.gsub("pages/fse", "pages/ise")
    intro_page.tab_two_contents = intro_page.tab_two_contents.gsub("pages/fse", "pages/ise")
    intro_page.tab_three_contents = intro_page.tab_three_contents.gsub("pages/fse", "pages/ise")
    intro_page.is_duplicated_page = true
    intro_page.updated_by_user_id = foundations_page.updated_by_user_id


    if intro_page.save
      puts "Page #{intro_page.id} (#{intro_page.url}) copied successfully from #{foundations_page.id} (#{foundations_page.url})."
    else
      puts "Page #{intro_page.url} not saved."
      puts "Error #{intro_page.errors} "
    end

    return true
  end


namespace :cmu do
  desc "Update ISE from FSE pages"
  task(:update_ise => :environment) do

    urls = ["fse", "fse_calendar", "fse_announcements", "fse_class_notes",
            "fse_rails_faq",
            "fse_task1", "fse_task2", "fse_task3", "fse_task4",
            "fse_task5", "fse_task6", ]
    urls.each do |url|
      update_ise_from_fse(url)
    end

    puts "Update ISE finished"
  end
end