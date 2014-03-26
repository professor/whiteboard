
Here are the directions on how to create the metrics for software engineering (MfSE) course
1. Go to a new directory

2. checkout the code
git clone git@github.com:professor/whiteboard.git
cd whiteboard

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

Spring 2013
GradebookFrontEnd
GradebookBackEnd and Assignments
Pages (and multi editors warning)
People Search
User
CourseConfiguration

Spring 2014
Assingments **
Courses * 
DeliverablesAndGradingQueue **
Gradebook **
Jobs **
LDAP **
Pages 
PeopleSearch *


To create the defected product, take all the teams zips and move over the files carefully
from app/controllers/ app/helpers, app/models/ app/views.
Remember to remove .git repo directory

Email to teams:

I have divided the application into several parts. You get to inject defects into the code found in this email's attachment. When you are done, please send the resulting zip to me (and cc your course instructor) and I will combine all the code from each team back into the product that will then be sent out to everyone.

Based upon feedback from last year, this year I'm also providing these files. Please DO NOT inject any defects into the following files. I will be using the master version of these files.
Gemfile
db/schema.rb
app/controllers/application_controller.rb
app/helpers/application_helper.rb
app/models/academic_calendar.rb
and the GenericMailer code

If there is anything else that you'd like to know, let me know. I may not be able to provide it, but I'll try.

Happy Defect Injecting,

Todd

Ps. Since gradebook is such a large piece of code base, I have divided the code into different use cases.


TeamCourseConfigurationAndAssignments -- this is the ability to configure a course and create assignments. Note that TeamDeliverables has models/grading_rule.rb

TeamDeliverables -- this is the student submission of a deliverable plus the faculty grading it

TeamGradebook -- this is the spreadsheet that allows the faculty to change any grades for a course. Note that you will probably want to work with TeamDeliverables on the controller/grades_controller.rb import and export method and models/grade.rb file. I suspect you will own the methods below import_grade_book_from_spreadsheet. I wanted to split up these two files, but it became too tricky to manage.

TeamPageComments -- note that this code is currently NOT live.
TeamPages --
TeamPeopleSearch -- pretty straightforward




Email to teams
Subject: MfSE Defected Code

First, great defects everyone! I couldn't resist looking at some of your injection logs. You are all very creative and I think you'll have fun trying to find these "easter eggs" inside the code base.

I have carefully reconstructed the project with your changes.  I then ran through the installation directions. I'll report that there are two defects in the pages.rb file that will prevent the server from starting up. With those lines commented out, lines 11 and 13, the system will start up. From that point on, it is relatively un-usable due to the defects.

I believe you are doing code reviews this week, so you'll experience the "joys" of the running system next week. The test suite won't run because of parsing defects. If your team fixes a parse defect, please let everyone know. I'm personally interested in knowing how many seeded defects are caught by the existing test suite.

I have a graduate student working on creating a VM for next week.

If you come across any configuration issues (as opposed to injected bugs), please let me know and maybe I can help.

Please see http://whiteboard.sv.cmu.edu/pages/mfse_team_sharing for who is working on each section this week.

You can download the code here: http://bureau.west.cmu.edu/~tturco/mfse_defected.zip
