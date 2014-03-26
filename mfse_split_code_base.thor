#require 'rails/generators/actions'


# thor mfse_split_code_base:copy_common_files Pages
class MfseSplitCodeBase < Thor
  include Thor::Actions


  desc "copy_common_files SECTION_NAME", "initialize a section, e.g. TeamCourses "
  # This copies files needed for every project
  def copy_common_files(section_name)

    section_directory = "Team" + section_name + "/"
    empty_directory section_directory

    project_directory = section_directory + "CMUEducation/"
    empty_directory project_directory

    empty_directory project_directory + "db"
    empty_directory project_directory + "app/models"
    empty_directory project_directory + "app/services"

    copy_file "Gemfile", project_directory + "Gemfile"
    copy_file "db/schema.rb", project_directory + "db/schema.rb"
    copy_file "app/controllers/application_controller.rb", project_directory + "app/controllers/application_controller.rb"
    copy_file "app/helpers/application_helper.rb", project_directory + "app/helpers/application_helper.rb"
    copy_file "app/mailers/generic_mailer.rb", project_directory + "app/mailers/generic_mailer.rb"
    directory "app/views/generic_mailer/", project_directory + "app/views/generic_mailer/"
    copy_file "app/services/academic_calendar.rb", project_directory + "app/services/academic_calendar.rb"

  end

  def self.source_root
     File.dirname(__FILE__)
   end
end