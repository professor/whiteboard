#Admin

## To view log files
    heroku logs --tail --app cmusv-ceddar


## To copy courses from one year to the next
    heroku pgbackups:capture --expire --app cmusv-cedar
    heroku run script/rails console --app cmusv-cedar
    Course.copy_courses_from_a_semester_to_next_year("Fall", 2013)
    Course.copy_courses_from_a_semester_to_next_year("Spring", 2014)
    Course.copy_courses_from_a_semester_to_next_year("Summer", 2014)

## To delete a course
    (optional) heroku pgbackups:capture --expire --app cmusv-cedar
    heroku run script/rails console --app cmusv-cedar
    c = Course.find(**ID**)
    c.delete

## Email faculty to configure (current semester)
    heroku run rake whiteboard:email_faculty_to_configure_current_semester_courses --app cmusv

## Email faculty to configure (next semester)
    heroku run rake whiteboard:email_faculty_to_configure_next_semester_courses --app cmusv

