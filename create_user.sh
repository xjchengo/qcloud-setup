#!/bin/bash
#create user and make it sudo

ROOT_UID=0
E_NOTROOT=87
nosudo=false
# Run as root
if [ "$UID" -ne "$ROOT_UID" ]
then
    echo "Must be root to run this script" >&2
    exit $E_NOTROOT
fi

while test $# -gt 0; do
    case "$1" in
        -u)
            user=$2
            shift 2
        ;;
        -p)
            password=$2
            shift 2
        ;;
        -n)
            nosudo=true
            shift 1
        ;;
        *)
            break
        ;;
    esac
done;

if [ -z "$user" ] || [ -z "$password" ]
then
    echo "Usage: $0 -u username -p password [-n]" >&2
    exit 1
fi

useradd -m -s /bin/bash $user

if [ $? -ne 0 ];then
    exit 1
else
    echo "Create User:$user successfully!"
fi

#set password
echo -e "$password\n$password" | passwd $user 1>/dev/null 2>&1

#sudo
if [ "$nosudo" = false ];then
    echo "$user    ALL=(ALL:ALL) ALL" > "/etc/sudoers.d/$user"
    chmod 440 "/etc/sudoers.d/$user"
    echo "sudo successfully!"
else
    echo "$user did not sudo."
fi
