#!/bin/bash

user=$(id -un)
role=$1

if [ "$role" == "student" ] 
    then update="is_staff='0', is_student='1',is_admin='0'"
elif [ "$role" = "staff" ] 
    then update="is_staff='1', is_student='0',is_admin='0'"
elif [ "$role" = "admin" ] 
    then update="is_staff='0', is_student='0',is_admin='1'"
else
    echo "unsupported role" >/dev/stderr
    exit 1
fi

if [ "$user" == "lydian" ] 
    then email="lydian.lee@sv.cmu.edu"
    elif [ "$user" == "kate" ]
    then email="kate.liu@sv.cmu.edu"
elif [ "$user" == "prabhjot" ]
    then email="prabhjot.singh@sv.cmu.edu"
else
    echo "unknown user" >/dev/stderr
    exit 1
fi  
fake_email="fake.$email"
echo $fake_email
echo "set $user(id=$uid) as  $role"
psql -d cmu_education -c "Update users SET email='$email' WHERE email='$fake_email' and is_$role='1'" >> /dev/null
psql -d cmu_education -c "Update users SET email='$fake_email' WHERE email='$email' and is_$role!='1'" >> /dev/null
psql -d cmu_education -c "SELECT email, is_$role FROM users WHERE email='$email' OR email='$fake_email'"

