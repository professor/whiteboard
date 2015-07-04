#Admin



## To view log files
    heroku logs --tail --app cmusv-cedar


## To copy courses from one year to the next
    heroku pg:backups capture --app cmusv-cedar
    heroku run script/rails console --app cmusv-cedar
    Course.copy_courses_from_a_semester_to_next_year("Fall", 2013)
    Course.copy_courses_from_a_semester_to_next_year("Spring", 2014)
    Course.copy_courses_from_a_semester_to_next_year("Summer", 2014)

## To delete a course
    (optional) heroku pg:backups capture --app cmusv-cedar
    heroku run script/rails console --app cmusv-cedar
    c = Course.find(**ID**)
    c.delete

## Email faculty to configure (current semester)
    heroku run rake whiteboard:email_faculty_to_configure_current_semester_courses --app cmusv-cedar

## Email faculty to configure (next semester)
    heroku run rake whiteboard:email_faculty_to_configure_next_semester_courses --app cmusv-cedar

## To flush all delayed system jobs
    heroku run script/rails console --app cmusv-cedar
    DelayedSystemJob.delete_all
	
	## To create an admin
    heroku run script/rails console --app cmusv-cedar
	user = User.find(1)
	user.is_admin = true
	user.save
	
	
## Deploying to production
	The master code base is located at http://github.com/professor/whiteboard
	To get code into the code base, fork the repository, make local modifications, verify that all the tests pass with rake, and do a pull reqeust to professor/whiteboard. The project owner responds to pull request quickly
	
	If you have the ability to push code directly to heroku, first setup a git remote to the heroku repo with heroku git:remote -a git@heroku.com:cmusv-cedar.git 

	To then deploy code
	git pull heroku master
	rake
	git push heroku master
	heroku pg:backups capture --app cmusv-cedar
	heroku run rake db:migrate --app cmusv-cedar   #this is only necessary if there are db schema changes

	For additional information see https://devcenter.heroku.com/articles/git

## To download the database locally
  heroku pg:pull HEROKU_POSTGRESQL_COLOR_URL cmu_education_heroku --app cmusv-cedar
	
