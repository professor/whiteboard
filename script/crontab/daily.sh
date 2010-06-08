#!/bin/sh

#You will need to chmod the permissions for this file on production
#chmod 755 script/crontab_rss.sh

#cron /home/webadmin/rails.sv.cmu.edu/html/CMUEducation/script/crontab_rss.sh
cd /home/webadmin/rails.sv.cmu.edu/html/CMUEducation
/usr/bin/rake rss RAILS_ENV=production
/usr/bin/rake please_do_peer_evaluation_email RAILS_ENV=production

