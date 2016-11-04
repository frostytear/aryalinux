#!/bin/bash
set -e
set +h

function preinstall()
{

groupadd -g 40 mysql &&
useradd -c "MySQL Server" -d /srv/mysql -g mysql -s /bin/false -u 40 mysql

}


postinstall()
{
echo "#"
}


$1
