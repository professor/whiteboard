CMUEducation::Application.routes.draw do
  resources :search, :only => [:index]
  resources :deliverables
  match '/people/:id/my_deliverables' => 'deliverables#my_deliverables', :as => :my_deliverables
  match '/deliverables/:id/feedback' => 'deliverables#edit_feedback', :as => :deliverable_feedback
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
  resources :curriculum_comment_types
  match '/curriculum_comments/test_page' => 'curriculum_comments#test_page'
  resources :curriculum_comments
  resources :scotty_dog_sayings
  resources :project_types
  resources :projects
  resources :task_types
  match '/effort_logs/update_task_type_select' => 'effort_logs#update_task_type_select', :as => :update_task_type_select
  match '/effort_logs/effort_for_unregistered_courses' => 'effort_logs#effort_for_unregistered_courses'
  resources :effort_logs
  resources :effort_log_line_items
  resources :course_numbers
  resources :course_configurations
  match '/courses/current_semester' => 'courses#current_semester', :as => :current_semester
  match '/courses/next_semester' => 'courses#next_semester', :as => :next_semester
  constraints({:id => /.*/}) do
    resources :mailing_lists
    resources :pages do
      collection do
        post :reposition
      end
    end
  end

  resources :course_navigations
  resources :courses do
    resources :teams do
    end
    member do
      get :configure
    end
  end

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
  match '/people/class_profile' => 'people#class_profile'
  match '/people/advanced' => 'people#advanced' #Just in case anyone bookmarked this url
  match '/people/photo_book' => 'people#photo_book'
  match '/people/:id/my_courses' => 'people#my_courses', :as => :my_courses
  match '/people/:id/my_teams' => 'people#my_teams', :as => :my_teams
  resources :people
  resources :suggestions
  match '/teams' => 'teams#index_all', :as => :teams

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" } do
    get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
    get 'logout' => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  #resources :users
  #resource :user_session

  #match '/login_google' => 'user_sessions#login_google', :as => :login_google
  #match '/logout' => "user_sessions#destroy", :as => :logout


  match '/load_chart' => 'effort_reports#load_chart', :as => :load_chart
  match 'people/twiki/:twiki_name' => 'people#show_by_twiki'
  match 'twiki/teams' => 'teams#twiki_index'
  match 'twiki/teams/new' => 'teams#twiki_new'
  match 'courses/:course_id/teams_photos' => 'teams#index_photos'
  match 'courses/:course_id/past_teams_list' => 'teams#past_teams_list', :as => :past_teams_list
  match 'courses/:course_id/export_to_csv' => 'teams#export_to_csv'
  match 'courses/:course_id/deliverables' => 'deliverables#index_for_course', :as => :course_deliverables
  match 'effort_reports/:id/week/:week' => 'effort_reports#show_week'
  match '/:controller(/:action(/:id))'
  match '/new_features' => 'welcome#new_features', :as => :new_features
  match '/config' => 'welcome#configuration', :as => :config
  match '/' => 'welcome#index', :as => :root
end

