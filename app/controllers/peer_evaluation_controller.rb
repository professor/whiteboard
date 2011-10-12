class PeerEvaluationController < ApplicationController
    layout 'cmu_sv'
    before_filter :authenticate_user!

    @@questions = [
      "What was this team member's most significant positive contribution to the team?",
      "In what ways could this team member improve his/her contribution to team meetings?",
      "In what ways could this team member improve his/her contribution to the team's deliverables? ",
      "Please provide feedback on the progress of each individual's improvement objective:"
    ]
    @@point_allocation = "Point allocations"

  def index_for_course
    @course = Course.find(params[:course_id])
    @teams = Team.where(:course_id => params[:course_id])
  end

  def edit_setup
    @team = Team.find(params[:id])
    @people = @team.people

    @objective = PeerEvaluationLearningObjective.new

    @objectives = []
    @team.people.each do |member|
       objective = PeerEvaluationLearningObjective.find(:first, :conditions => {:team_id => @team.id, :person_id => member.id})
       if objective.nil?
         @objectives << PeerEvaluationLearningObjective.new
       else
        @objectives << objective
       end
    end
  end

  def complete_setup
    @team = Team.find(params[:id])

    counter = 0

    @team.people.each do |member|
      if(PeerEvaluationLearningObjective.find(:first, :conditions => {:team_id => @team.id, :person_id => member.id}).nil?)
        @objective = PeerEvaluationLearningObjective.new(
          :team_id => params[:id],
          :person_id => member.id,
          :learning_objective => params[:peer_evaluation_learning_objective][counter.to_s][:learning_objective]
        )
      else
        @objective = PeerEvaluationLearningObjective.find(:first, :conditions => {:team_id => @team.id, :person_id => member.id})
        @objective.learning_objective = params[:peer_evaluation_learning_objective][counter.to_s][:learning_objective]
      end

      @objective.save!
      counter += 1
    end

    flash[:notice] = "Learning objectives have been updated."
    redirect_to(peer_evaluation_path(@team.course, @team.id))
  end


  def edit_evaluation
    @questions = @@questions
    @team = Team.find(params[:id])
    @people = @team.people
    @author = Person.find(current_user.id)
    @answers = []
    @point_allocations = {}
    @review = PeerEvaluationReview.new

    @on_team = false
    @people.each do |person|
      if(person.human_name == current_user.human_name)
        @on_team = true
      end
    end

    if(@on_team == false)
      if (current_user.is_staff || current_user.is_admin)
        return
      end
      flash[:error] = "You are not on team #{@team.name}"
      redirect_to(peer_evaluation_path(@team.course, @team.id))
      return
    end

    personcounter = 0
    questioncounter = 0
    alloccounter = 0

    @people.each do |person|
      @questions.each do |question|
        evaluation = PeerEvaluationReview.find(:first,:conditions => {:author_id => @author.id, :recipient_id => person.id, :team_id => @team.id, :question => question})
        if(evaluation.nil?)
          @answers << ""
        else
          @answers << evaluation.answer
        end
        questioncounter += 1
      end

      personcounter += 1
      questioncounter = 0
    end

   allocation = PeerEvaluationReview.find(:first,:conditions => {:author_id => @author.id, :team_id => @team.id, :question => @@point_allocation})
   unless allocation.nil? || allocation.answer.nil?
    match_array = allocation.answer.scan /((\w| )*):(\d*)\s*/
   match_array.each do |match|
     name = match[0]
     points = match[2]
     @point_allocations[name] = points
   end
  end

    #    @allocAnswer = ""
#    @people.each do |person|
#      @allocAnswer << person.human_name + ":" + params[:allocations][alloccounter] + " "
#      alloccounter += 1
#    end
#
#    @allocations = PeerEvaluationReview.new(
#      :author_id => @author.id,
#      :team_id => @team.id,
#      :question => "Point allocations",
#      :answer => @allocAnswer,
#      :sequence_number => questioncounter
#    )
#    @allocations.save!

  end


  def complete_evaluation
    @questions = @@questions

    @team = Team.find(params[:id])
    @people = @team.people

    @author = Person.find(current_user.id)

    personcounter = 0
    questioncounter = 0
    alloccounter = 0

    @people.each do |person|
      @questions.each do |question|
        @evaluation = PeerEvaluationReview.find(:first,:conditions => {:author_id => @author.id, :recipient_id => person.id, :team_id => @team.id, :question => question})
        if(@evaluation.nil?)
          @evaluation = PeerEvaluationReview.new(
            :author_id => @author.id,
            :recipient_id => person.id,
            :team_id => @team.id,
            :question => question,
            :answer => params[:peer_evaluation_review][(@questions.size*personcounter + questioncounter).to_s][:answer],
            :sequence_number => questioncounter
          )
        else
          @evaluation.answer = params[:peer_evaluation_review][(@questions.size*personcounter + questioncounter).to_s][:answer]
        end
        @evaluation.save!
        questioncounter += 1
      end

      personcounter += 1
      questioncounter = 0
    end

      allocAnswer = ""
      @people.each do |person|
        allocAnswer << person.human_name + ":" + params[:allocations][alloccounter] + " "
        alloccounter += 1
      end

      allocation = PeerEvaluationReview.find(:first,:conditions => {:author_id => @author.id, :team_id => @team.id, :question => @@point_allocation})
      if(allocation.nil?)
        allocation = PeerEvaluationReview.new(
          :author_id => @author.id,
          :team_id => @team.id,
          :question => @@point_allocation,
          :answer => allocAnswer,
          :sequence_number => questioncounter
        )
      else
        allocation.answer = allocAnswer
      end
      allocation.save!

    flash[:notice] = "Thank you for completing the peer evaluation form."
    redirect_to(peer_evaluation_path(@team.course, @team.id))
  end

  def complete_evaluation_old
    @questions = @@questions

    @team = Team.find(params[:id])
    @people = @team.people

    @author = Person.find(current_user.id)

    personcounter = 0
    questioncounter = 0
    alloccounter = 0

    @people.each do |person|
      @questions.each do |question|
        if(PeerEvaluationReview.find(:first,:conditions => {:author_id => @author.id, :recipient_id => person.id, :team_id => @team.id, :question => question}).nil?)
          @evaluation = PeerEvaluationReview.new(
            :author_id => @author.id,
            :recipient_id => person.id,
            :team_id => @team.id,
            :question => question,
            :answer => params[:peer_evaluation_review][(@questions.size*personcounter + questioncounter).to_s][:answer],
            :sequence_number => questioncounter
          )
        else
          @evaluation = PeerEvaluationReview.find(:first,:conditions => {:author_id => @author.id, :recipient_id => person.id, :team_id => @team.id, :question => question})
          @evaluation.answer = params[:peer_evaluation_review][(@questions.size*personcounter + questioncounter).to_s][:answer]
        end
        @evaluation.save!
        questioncounter += 1
      end

      personcounter += 1
      questioncounter = 0
    end

    @allocAnswer = ""
    @people.each do |person|
      @allocAnswer << person.human_name + ":" + params[:allocations][alloccounter] + " "
      alloccounter += 1
    end

    @allocations = PeerEvaluationReview.new(
      :author_id => @author.id,
      :team_id => @team.id,
      :question => "Point allocations",
      :answer => @allocAnswer,
      :sequence_number => questioncounter
    )
    @allocations.save!

    flash[:notice] = "Thank you for saving the peer evaluation form."
    redirect_to(peer_evaluation_path(@team.course, @team.id))
  end

  def edit_report
    @team = Team.find(params[:id])
    @people = @team.people

    @report = PeerEvaluationReport.new

    @incompletes = Array.new
    @team.people.each do |member|
      unless PeerEvaluationReview.is_completed_for?(member.id, @team.id)
        @incompletes << (member)
      end
    end

    @reportArray = Array.new(@people.size)
    personcounter = 0
    @people.each do |person|
      @reportArray[personcounter] = generate_report_for_student(person.id, @team.id)
      personcounter += 1
    end

    @report_allocations = {}
    @point_allocations = Hash.new { |hash, key| hash[key] = {} }  #two dimensional hash
    @people.each do |person|
       tmp = person.human_name
       allocation = PeerEvaluationReview.find(:first,:conditions => {:author_id => person.id, :team_id => @team.id, :question => @@point_allocation})
       unless allocation.nil?
          @report_allocations[person.human_name] = allocation.answer

      match_array = allocation.answer.scan /((\w| )*):(\d*)\s*/
       match_array.each do |match|
         name = match[0]
         points = match[2]
         @point_allocations[person.human_name][name] = points
       end
      end
    end

  end

  def complete_report
    @team = Team.find(params[:id])
    @people = @team.people
    personcounter = 0

    @people.each do |person|
      #Step 1 save feedback
      feedback = params[:peer_evaluation_report][personcounter.to_s][:feedback]
      report = PeerEvaluationReport.find(:first,:conditions => {:recipient_id => person.id, :team_id => @team.id})
      if report.nil?
        report = PeerEvaluationReport.new(:recipient_id => person.id, :team_id => @team.id, :feedback => feedback)
      else
        report.feedback = feedback
    end

    report.email_date = Date.today
    report.save!

    faculty = @team.faculty_email_addresses()

    #Step 2 email feedback
    if params[:commit] == "Save And Email All"
      options = {:to => person.email, :cc => faculty, :subject => "Peer evaluation feedback from team #{@team.name}",
                  :message => feedback.gsub("\n", "<br/>"), :url => "", :url_label => ""}
      GenericMailer.email(options).deliver

    # ---------- Rails 2 Implementation ----------

    #     GenericMailer.deliver_email(
    #          :to => person.email,
    #          :subject => "Peer evaluation feedback from team #{@team.name}",
    #          :message => feedback.gsub("\n", "<br/>"),
    #          :url_label => "",
    #          :url => "",
    ##         :from => current_user.email,  Spam filters block it if the email from is different than the account it is sent from.
    #          :cc => faculty
    #)
    end

    personcounter += 1
    end

    flash[:notice] = "Reports have been successfully saved."
    redirect_to(peer_evaluation_path(@team.course, @team.id))
  end


  def email_reports

  end


  def create_please_do_evaluation_email

    teams = Team.all
    emails_sent = 0

    #teams = Team.find(:all, :conditions => ["id = ? ", "215"])
    teams.each do |team|
      #puts "Team: " + team.name + " (" + team.id.to_s + ") "
      unless team.peer_evaluation_first_email.nil? && team.peer_evaluation_second_email.nil?
        first_date_p = Date.today == team.peer_evaluation_first_email.to_date unless team.peer_evaluation_first_email.nil?
        second_date_p = Date.today == team.peer_evaluation_second_email.to_date unless team.peer_evaluation_second_email.nil?
        if ((first_date_p) ||
            (second_date_p))

          puts "Team: " + team.name + " (" + team.id.to_s + ") "
          puts "First email date: " + team.peer_evaluation_first_email.to_s
          puts "Second email date: " + team.peer_evaluation_second_email.to_s
          puts "Today: " + Date.today.to_s
          puts "1st comparison is true " if Date.today == team.peer_evaluation_first_email.to_date
          puts "2nd comparison is true " if Date.today == team.peer_evaluation_second_email.to_date
          puts ""

          #from_address = "scotty.dog@sv.cmu.edu"
          faculty = team.faculty_email_addresses()

          if first_date_p
            to_address = team.email
            to_address = []
            team.people.each do |person|
              to_address << person.email
            end
            send_email(team, faculty, to_address, team.peer_evaluation_message_one)
            emails_sent += 1
          elsif second_date_p
            to_address_done = []
            to_address_incomplete = []
            team.people.each do |person|
              if PeerEvaluationReview.is_complete_for?(person_id,team_id)
                to_address_done << person.email
              else
                to_address_incomplete << person.email
              end
            end
            send_email(team, faculty, to_address_done, team.peer_evaluation_message_two_done)
            send_email(team, faculty, to_address_incomplete, team.peer_evaluation_message_two_incomplete)
            emails_sent += 2
          end

        end
      end
    end

    return emails_sent
  end


  private
  def send_email(team, faculty, to_address, message)
    options = {:to => to_address, :cc => faculty, :bcc => "todd.sedano@sv.cmu.edu",
               :subject => "peer evaluation for team #{team.name}",
               :message => message, :url => "http://rails.sv.cmu.edu/peer_evaluation/edit_evaluation/#{team.id}",  # + edit_peer_evaluation_path(team))
               :url_label => "Complete the survey now"}
    GenericMailer.email(options).deliver

    # ---------- Rails 2 Implementation ----------
    #         GenericMailer.deliver_email(
    #           :bcc => "todd.sedano@sv.cmu.edu",
    #           :to => to_address,
    #           :subject => "peer evaluation for team #{team.name}",
    #           :message => message,
    #           :url_label => "Complete the survey now",
    #           :url => "http://rails.sv.cmu.edu/peer_evaluation/edit_evaluation/#{team.id}", # + edit_peer_evaluation_path(team))
    #           :from => from_address,
    #           :cc => faculty
    #          )
  end


  def generate_report_for_student(person_id, team_id)
    report = PeerEvaluationReport.find(:first,:conditions => {:recipient_id => person_id, :team_id => team_id})
    if report.nil?
      report_string = ""
        #report_string += "{" + person.human_name + "}\n"
      questioncounter = 0
      @@questions.each do |question|
        report_string += question + "\n"
        if questioncounter == @@questions.size - 1
          learning_objective = PeerEvaluationLearningObjective.find(:first, :conditions => {:person_id => person_id})
          report_string += "\"" + learning_objective.learning_objective + "\"\n" unless (learning_objective.nil? || learning_objective.learning_objective.nil? || learning_objective.learning_objective.empty?)
        end
        data = PeerEvaluationReview.find(:all, :conditions => {:team_id => team_id, :recipient_id => person_id, :question => question})
        data.each do |answer|
          author = Person.find(answer.author_id).human_name
          report_string += "[" + author + "]\n"
          report_string += " - " + answer.answer + "\n"
        end
        report_string += "\n"
        questioncounter += 1
      end
      return report_string
    else
      return report.feedback
    end

  end


end
