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

    copy_file "Gemfile", project_directory + "Gemfile"
    copy_file "db/schema.rb", project_directory + "db/schema.rb"
    copy_file "app/controllers/application_controller.rb", project_directory + "app/controllers/application_controller.rb"
    copy_file "app/helpers/application_helper.rb", project_directory + "app/helpers/application_helper.rb"
    copy_file "app/mailers/generic_mailer.rb", project_directory + "app/mailers/generic_mailer.rb"
    directory "app/views/generic_mailer/", project_directory + "app/views/generic_mailer/"

  end

  def self.source_root
     File.dirname(__FILE__)
   end

  desc "create_project TEAM_NAME", "create a team project"
  def create_project(project, name)
    project_directory = "Fall-" + @@year + "-" + @@course + "-" + name
    run "git init"
    run "rails new " + project + " -v 3.2.7 --skip-test-unit"
    run "mv " + project + "/* ."
    run "mv " + project + "/.[^.]* ." #Move .files
    remove_dir project
    update_gemfile
    update_git_file
    create_rvmrc
    modify_readme_with_build_status name
    rename_readme
    run "git add ."
    run "git commit -m 'Adding in initial repo'"
  end


end