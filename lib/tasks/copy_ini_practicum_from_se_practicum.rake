require 'rubygems'
require 'rake'
require 'rails'

  def copy_ini_practicum_from_se_practicum
    from_course = Course.find_by_name("Software Engineering Practicum")
    to_course = Course.find_by_name("INI Practicum")


    from_course.pages.each do |from_page|
      from_url = from_page.url
      to_url = from_url.gsub("se_", "ini_")
      to_page = Page.find_by_url(to_url)

      if to_page.nil?
        puts "--Create a new page"
        # intro_page = foundations_page.dup #dup isn't working quite right for 3.0.9
        to_page = Page.new(from_page.attributes)
      else
        puts "--Copy from existing page"
        to_id = to_page.id
        to_page.attributes = from_page.attributes
        to_page.id = to_id
      end

      to_page.course_id = to_course.id
      to_page.url = to_url
      to_page.tab_one_contents = to_page.tab_one_contents.gsub("pages/se_", "pages/ini_")
      to_page.tab_two_contents = to_page.tab_two_contents.gsub("pages/se_", "pages/ini_")
      to_page.tab_three_contents = to_page.tab_three_contents.gsub("pages/se_", "pages/ini_")
#      to_page.is_duplicated_page = true
      to_page.updated_by_user_id = from_page.updated_by_user_id

      # This does not work
      #from_page.page_attachments.each do |attachment|
      #  new_attachment = attachment
      #  new_attachment.page_id = to_page.id
      #  to_page.page_attachments << new_attachment
      #end

      if to_page.save
        puts "Page #{to_page.id} (#{to_page.url}) copied successfully from #{from_page.id} (#{from_page.url})."
      else
        puts "Page #{to_page.url} not saved."
        puts "Error #{to_page.errors} "
      end


    end



end


namespace :cmu do
  desc "Copy INI Practicum from SE Practicum"
  task(:copy_ini_practicum => :environment) do

    copy_ini_practicum_from_se_practicum

    #urls = ["foundations", "foundations_calendar", "foundations_rails_faq",
    #        "foundations_task1", "foundations_task2", "foundations_task3", "foundations_task4",
    #        "foundations_task5", "foundations_task6", "foundations_class_notes"]
    #urls.each do |url|
    #  update_intro_from_foundations(url)
    #end

    puts "Copy finished"
  end
end