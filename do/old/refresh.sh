export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"
apt-get update && DEBIAN_FRONTEND=noninteractive apt-get upgrade -y --with-new-pkgs && apt-get autoremove -y && apt-get clean
cd /path/to/yourapp && mg stop
service redis-server stop
shutdown -r now