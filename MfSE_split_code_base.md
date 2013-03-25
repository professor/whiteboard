
Here are the directions on how to create the metrics for software engineering (MfSE) course
1. Go to a new directory

2. checkout the code
git clone git@github.com:professor/cmusv.git
cd cmusv

3. create a filelist
(Note: there are better ways of doing this)
find ./ *.* > alldirnfiles.txt

4. change secret token
vi config/initializers/secret_token.rb

5. remove 'scotty.dog@sv.cmu.edu' in these files:
vi app/mailers/effort_log_mailer.rb

6. split code into segments

What do I want in every team segment?
Gemfile
db/schema.rb
app/controllers/application_controller.rb
app/helpers/application_helper.rb
app/mailers/generic_mailer.rb
app/views/generic_mailer/*
app/models/academic_calendar.rb

thor mfse_split_code_base:copy_common_files Pages


GradebookFrontEnd
GradebookBackEnd and Assignments
Pages (and multi editors warning)
People Search
User
CourseConfiguration



To create the defected product, take all the teams zips and move over the files carefully
from app/controllers/ app/helpers, app/models/ app/views.


Email to teams:

I have divided the application into several parts. You get to inject defects into the code found in this email's attachment. When you are done, please send the resulting zip to me (and cc your course instructor) and I will combine all the code from each team back into the product that will then be sent out to everyone.

Based upon feedback from last year, this year I'm also providing these files. Please DO NOT inject any defects into the following files. I will be using the master version of these files.
app/controllers/application_controller.rb
app/helpers/application_helper.rb
db/schema.rb
Gemfile
and the GenericMailer code

If there is anything else that you'd like to know, let me know. I may not be able to provide it, but I'll try.

Happy Defect Injecting,

Todd


