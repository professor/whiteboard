class JobMailer < ActionMailer::Base
  default :from => 'CMU-SV Official Communication <help@sv.cmu.edu>',
          :bcc => ["todd.sedano@sv.cmu.edu", "rails.app@sv.cmu.edu"]

  def notify_hr(job, added_people, removed_people)
    message = "Action required: please update billing records<br/>"

    if added_people.present?
      message += "The following people were added<br/>"
      added_people.each do |user|
        message += "#{user.human_name}<br/>"
      end
    end
    message += "<br/>"

    if removed_people.present?
      message += "The following people were removed<br/>"
      removed_people.each do |user|
        message += "#{user.human_name}<br/>"
      end
    end

    options = {#:to => "sylvia.arifin@sv.cmu.edu",
               :to => "todd.sedano@sv.cmu.edu",
               :subject => "GA Jobs - people assigned to a project changed - " + job.title,
               :message => message,
               :url_label => "View this job",
               :url => "http://whiteboard.sv.cmu.edu/jobs",
#               :url => Rails.application.routes.url_helpers.edit_job_url(job, :host => "whiteboard.sv.cmu.edu"),
               :template_path => 'generic_mailer',
               :template_name => 'email',
               :date => Time.now
    }
    GenericMailer.email(options).deliver

  end


  def notify_added_employees(job, added_people)
    @job = job
    if added_people.present?
      added_people.each do |user|
        options = {:to => user.email,
                   :cc => job.supervisors.collect { |user| user.email },
                   :bcc => ["sylvia.arifin@sv.cmu.edu", "todd.sedano@sv.cmu.edu"],
                   :subject => "GA Jobs - you've been added to " + job.title,
                   :date => Time.now,
        }
        mail(options).deliver
      end
    end

  end

  def notify_removed_employees(job, removed_people)
    message = "You've been removed from the project " + job.title

    if removed_people.present?
      removed_people.each do |user|
        options = {:to => user.email,
                   :cc => job.supervisors.collect { |user| user.email },
                   :bcc => ["sylvia.arifin@sv.cmu.edu", "todd.sedano@sv.cmu.edu"],
                   :subject => "GA Jobs - you've been removed from " + job.title,
                   :message => message,
                   :date => Time.now,
                   :template_path => 'generic_mailer',
                   :template_name => 'email'
        }
        GenericMailer.email(options).deliver
      end
    end

  end


end
