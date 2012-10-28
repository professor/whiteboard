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
    then uid=998
elif [ "$user" == "kate" ]
    then uid=999
elif [ "$user" == "prabhjot" ]
    then uid=997
else
    echo "unknown user" >/dev/stderr
    exit 1
fi  

echo "set $user(id=$uid) as  $role"
psql -d cmu_education -c "Update users SET $update WHERE id=$uid" >> /dev/null
echo "Your current status"
psql -d cmu_education -c "SELECT id, human_name, is_staff, is_student, is_admin FROM users WHERE id=$uid"

