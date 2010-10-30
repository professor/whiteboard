ActionController::Routing::Routes.draw do |map|
  map.resources :deliverables


  map.connect 'delayed_system_jobs/',  :controller => 'delayed_system_jobs', :action => "index"
  map.resources :delayed_system_jobs #so that we can easily delete

  map.connect 'papers/by/:twiki_name', :controller => 'papers', :action => 'index_by_person'
  map.resources :papers

  map.resources :mailing_lists, :requirements => {:id => /\S+/}
  #At present we only do index and show

  map.resources :rss_feeds #I don't think we need this here

#  map.connect 'pages/:id/:tab',  :controller => 'pages', :action => "show"
  map.resources :pages

  map.resources :curriculum_comment_types

  map.connect '/curriculum_comments/test_page', :controller => 'curriculum_comments', :action => 'test_page'
  map.resources :curriculum_comments

  map.resources :scotty_dog_sayings

  map.resources :project_types

  map.resources :projects


  map.resources :task_types

#  map.connect '/effort_logs/create_midweek_warning_email', :controller => 'effort_logs', :action => 'create_midweek_warning_email'
#  map.connect '/effort_logs/create_endweek_faculty_email', :controller => 'effort_logs', :action => 'create_endweek_faculty_email'
  map.connect '/effort_logs/effort_for_unregistered_courses', :controller=>'effort_logs', :action => 'effort_for_unregistered_courses'
  map.resources :effort_logs
  map.resources :effort_log_line_items


  map.resources :course_numbers
  map.current_semester '/courses/current_semester', :controller => 'courses', :action => 'current_semester'
  map.next_semester '/courses/next_semester', :controller => 'courses', :action => 'next_semester'
  map.resources :pages, :collection => { :reposition => :post }
  map.resources :course_navigations
  map.resources :courses, :has_many => :teams

    map.connect '/effort_reports/campus_week', :controller => 'effort_reports', :action => 'campus_week'
    map.connect '/effort_reports/campus_semester', :controller => 'effort_reports', :action => 'campus_semester'
    map.connect '/effort_reports/course/:course_id', :controller => 'effort_reports', :action => 'course'

  
  map.resources :effort_reports

  map.connect '/people/phone_book', :controller => 'people', :action => 'phone_book'
  map.connect '/people/photo_book', :controller => 'people', :action => 'photo_book'
  map.my_teams '/people/:id/my_teams', :controller => 'people', :action => 'my_teams'
  map.resources :people

  map.resources :suggestions

  map.setup_peer_evaluation 'peer_evaluation/edit_setup/:id', :controller => "peer_evaluation", :action => "edit_setup"
  map.edit_peer_evaluation 'peer_evaluation/edit_evaluation/:id', :controller => "peer_evaluation", :action => "edit_evaluation"
  map.report_peer_evaluation 'peer_evaluation/edit_report/:id', :controller => "peer_evaluation", :action => "edit_report"

#  map.with_options :controller => "teams" do |page|
#    page.conce
#   page.concept_for_b_view  '/concept_for_b_view', :action => 'all'
# end  
  map.teams '/teams', :controller => 'teams', :action => 'index_all'
  
  map.resources :users

  map.resource :user_session
  map.login_google '/login_google', :controller => 'user_sessions', :action => 'login_google'

  
  map.load_chart '/load_chart', :controller => 'effort_reports', :action => 'load_chart' 
#  map.load_google_chart '/load_google_chart', :controller => 'effort_reports', :action => 'load_google_chart'


  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect 'people/twiki/:twiki_name', :controller => 'people', :action => 'show_by_twiki'
  map.connect 'twiki/teams', :controller => 'teams', :action => 'twiki_index'
  map.connect 'twiki/teams/new', :controller => 'teams', :action => 'twiki_new'

  map.survey_monkey 'courses/:course_id/teams/:id/survey_monkey', :controller => 'teams', :action => 'survey_monkey'
  map.connect 'courses/:course_id/teams_photos', :controller => 'teams', :action => 'index_photos'
  map.connect 'effort_reports/:id/week/:week',  :controller => 'effort_reports', :action => "show_week"

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

  map.new_features '/new_features', :controller => "welcome", :action => "new_features"
  map.config '/config', :controller => "welcome", :action => "config"
  
  map.root :controller => "welcome"
end
