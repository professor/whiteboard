#!/bin/sh

#You will need to chmod the permissions for this file on production
#chmod 755 script/crontab_rss.sh

#cron /home/webadmin/rails.sv.cmu.edu/html/CMUEducation/script/crontab/effort_log_midweek_warning_email.sh
cd /home/webadmin/rails.sv.cmu.edu/html/CMUEducation
/usr/bin/rake effort_log_midweek_warning_email RAILS_ENV=production


