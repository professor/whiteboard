CMUEducation::Application.routes.draw do

  #temporary for Mel
  match 'courses/:course_id/team_deliverables' => 'deliverables#team_index_for_course', :as => :individual_deliverables
  match 'courses/:course_id/individual_deliverables' => 'deliverables#individual_index_for_course', :as => :team_deliverables

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" } do
    get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
    get 'logout' => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  constraints(:host => /rails.sv.cmu.edu/) do
    match "/*path" => redirect {|params, req| "http://whiteboard.sv.cmu.edu/#{params[:path]}"}
  end

  resources :search, :only => [:index]
  #get    "/deliverables/get_assignments_for_student(.:format)" =>  "deliverables#get_assignments_for_student"

  match '/deliverables/get_assignments_for_student(.:format)'=> 'deliverables#get_assignments_for_student' ,:as=> :get_assignments_for_student
  resources :deliverables

  match '/people/:id/my_deliverables' => 'deliverables#my_deliverables', :as => :my_deliverables
  match '/people/:id/my_presentations' => 'presentations#my_presentations', :as => :my_presentations

  match '/deliverables/:id/feedback' => 'deliverables#edit_feedback', :as => :deliverable_feedback
  match '/presentations/:id/show_feedback' => 'presentations#show_feedback', :as => :show_feedback_for_presentation, :via => :get
  match '/presentations/:id/edit_feedback' => 'presentations#update_feedback', :via => :put
  match '/presentations/:id/edit_feedback' => 'presentations#edit_feedback', :as => :edit_feedback_for_presentation, :via => :get
  match '/presentations/:id/feedback' => 'presentations#create_feedback', :via => :post
  match '/presentations/:id/feedback' => 'presentations#new_feedback', :as => :new_presentation_feedback, :via => :get
  match '/presentations/today' => 'presentations#today', :as => :today_presentations
  resources :presentations, :only => [:index]

  match '/sponsored_projects/:id/archive' => 'sponsored_projects#archive', :as => :archive_sponsored_project
  match '/sponsored_project_sponsors/:id/archive' => 'sponsored_project_sponsors#archive', :as => :archive_sponsored_project_sponsor
  match '/sponsored_project_allocations/:id/archive' => 'sponsored_project_allocations#archive', :as => :archive_sponsored_project_allocation
  resources :sponsored_projects
  resources :sponsored_project_sponsors
  resources :sponsored_project_allocations
  resources :sponsored_project_efforts
  match 'delayed_system_jobs/' => 'delayed_system_jobs#index'
  resources :delayed_system_jobs
  resources :rss_feeds
  resources :page_comment_types
  resources :page_comments
  resources :scotty_dog_sayings
  resources :task_types
  match '/effort_logs/update_task_type_select' => 'effort_logs#update_task_type_select', :as => :update_task_type_select
  match '/effort_logs/effort_for_unregistered_courses' => 'effort_logs#effort_for_unregistered_courses'
  resources :effort_logs
  resources :effort_log_line_items
  resources :effort_log_line_items
  resources :course_numbers
  resources :course_configurations

  match '/courses/current_semester' => redirect("/courses/semester/#{AcademicCalendar.current_semester()}#{Date.today.year}"), :as => :current_semester
  match '/courses/next_semester' => redirect("/courses/semester/#{AcademicCalendar.next_semester()}#{AcademicCalendar.next_semester_year}"), :as => :next_semestrseer
  match '/course/:course_id/grades/send_final_grade' => 'grades#send_final_grade', :as=>:send_final_grade, :via => :post
  match '/course/:course_id/grades/post_drafted_and_send' => 'grades#post_drafted_and_send', :as=>:post_drafted_and_send, :via => :post
  match '/course/:course_id/grades/save' => 'grades#save', :as=>:save, :via => :post
  match '/course/:course_id/grades/export' => 'grades#export', :as=>:export, :via => :post
  match '/course/:course_id/grades/import' => 'grades#import', :as=>:import, :via => :post
  resources :courses do
    resources :assignments
    resources :grades
  end


  constraints({:id => /.*/}) do
    resources :mailing_lists
    resources :pages do
      collection do
        post :reposition
        get :changed
      end
    end
  end

  resources :page_attachments

  resources :course_navigations
  resources :courses do
    resources :teams do
    end
    member do
      get :configure
    end
    resources :presentations, :only => [:new, :edit, :create, :update]
  end


  match 'courses/semester/:semester' => 'courses#index_for_semester', :as => "semester_courses"
  match '/courses/:course_id/peer_evaluations' => 'peer_evaluation#index_for_course', :via => :get, :as => "peer_evaluations"
  match '/courses/:course_id/teams/:id/peer_evaluation' => 'teams#peer_evaluation', :via => :get, :as => "peer_evaluation"
  match '/courses/:course_id/teams/:id/peer_evaluation_update' => 'teams#peer_evaluation_update', :via => :post, :as => "peer_evaluation_update"
  match 'peer_evaluation/edit_setup/:id' => 'peer_evaluation#edit_setup', :as => :setup_peer_evaluation
  match 'peer_evaluation/edit_evaluation/:id' => 'peer_evaluation#edit_evaluation', :as => :edit_peer_evaluation
  match 'peer_evaluation/edit_report/:id' => 'peer_evaluation#edit_report', :as => :report_peer_evaluation

  match '/effort_reports/campus_week' => 'effort_reports#campus_week'
  match '/effort_reports/campus_semester' => 'effort_reports#campus_semester'
  match '/effort_reports/course/:course_id' => 'effort_reports#course'
  resources :effort_reports
  match '/people_autocomplete' => 'people#index_autocomplete'
  match '/people_search' => 'people#search'

  match '/people_csv' => 'people#download_csv'
  match '/people_vcf' => 'people#download_vcf'

  match '/people/class_profile' => 'people#class_profile'
  match '/people/ajax_check_if_email_exists' => 'people#ajax_check_if_email_exists'
  match '/people/ajax_check_if_webiso_account_exists' => 'people#ajax_check_if_webiso_account_exists'
  match '/people/advanced' => 'people#advanced' #Just in case anyone bookmarked this url
  match '/people/photo_book' => 'people#photo_book'
  match '/people/:id/my_courses_verbose' => 'people#my_courses_verbose', :as => :my_courses
  match '/people/:id/my_courses' => 'people#my_courses', :as => :my_courses
  match '/people/:id/my_teams' => 'people#my_teams', :as => :my_teams
  resources :people
  resources :users, :controller => 'people'
  resources :suggestions
  match '/teams' => 'teams#index_all', :as => :teams



  #resources :users
  #resource :user_session

  #match '/login_google' => 'user_sessions#login_google', :as => :login_google
  #match '/logout' => "user_sessions#destroy", :as => :logout


  match '/load_chart' => 'effort_reports#load_chart', :as => :load_chart
  match 'people/twiki/:twiki_name' => 'people#show_by_twiki'
  match 'twiki/teams' => 'teams#twiki_index'
  match 'twiki/teams/new' => 'teams#twiki_new', :via => :get
  match 'courses/:course_id/teams_photos' => 'teams#index_photos'
  match 'courses/:course_id/past_teams_list' => 'teams#past_teams_list', :as => :past_teams_list
  match 'courses/:course_id/export_to_csv_old' => 'teams#export_to_csv'
  match 'courses/:course_id/export_to_csv' => 'courses#export_to_csv'
  match 'courses/:course_id/team_formation_tool' => 'courses#team_formation_tool', :as => :team_formation_tool
  match 'courses/:course_id/student_grades' => 'deliverables#student_deliverables_and_grades_for_course', :as => :course_student_grades
  match 'courses/:course_id/deliverables' => 'deliverables#index_for_course', :as => :course_deliverables
  match 'courses/:course_id/presentations' => 'presentations#index_for_course', :as => :course_presentations



  #match 'courses/:course_id/presentations/update' => 'presentations#create',:via => :post, :as => :new_course_presentation
  #match 'courses/:course_id/presentations/edit' => 'presentations#edit', :as => :new_course_presentation
  #match 'courses/:course_id/presentations/new' => 'presentations#create',:via => :post, :as => :new_course_presentation
  #match 'courses/:course_id/presentations/new' => 'presentations#new', :as => :new_course_presentation

  match 'effort_reports/:id/week/:week' => 'effort_reports#show_week'
  match '/:controller(/:action(/:id))'

  match 'static/:action' => 'static#:action'
  match '/new_features' => 'welcome#new_features', :as => :new_features
  match '/config' => 'welcome#configuration', :as => :config
  match '/' => 'welcome#index', :as => :root

end

