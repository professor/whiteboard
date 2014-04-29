#Admin

## To view log files
heroku logs --tail --app cmusv-ceddar


## To copy courses from one year to the next
heroku run script/rails console --app cmusv-cedar
Course.copy_courses_from_a_semester_to_next_year("Fall", 2013)
Course.copy_courses_from_a_semester_to_next_year("Spring", 2014)
Course.copy_courses_from_a_semester_to_next_year("Summer", 2014)




