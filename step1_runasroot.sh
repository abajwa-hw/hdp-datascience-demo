
echo "Stopping Oozie..."
su -l oozie -c "cd /var/log/oozie; /usr/lib/oozie/bin/oozied.sh stop"

echo "Stopping WebHCat..."
su -l hcat -c "/usr/lib/hive-hcatalog/sbin/webhcat_server.sh stop"

echo "Stopping Tez..."
su -l tez -c "/usr/lib/tez/sbin/tez-daemon.sh stop ampoolservice"

echo "Stopping Hive..."
ps aux | awk '{print $1,$2}' | grep hive | awk '{print $2}' | xargs kill >/dev/null 2>&1

set -e

#install mvn as root
mkdir /usr/share/maven
cd /usr/share/maven
wget http://mirrors.koehn.com/apache/maven/maven-3/3.2.5/binaries/apache-maven-3.2.5-bin.tar.gz
tar xvzf apache-maven-3.2.5-bin.tar.gz
ln -s /usr/share/maven/apache-maven-3.2.5/ /usr/share/maven/latest

yum update -y --skip-broken
yum install gcc gcc-c++ gcc-gfortran -y
yum install zlib-devel bzip2-devel openssl-devel xz-libs wget -y
yum install sqlite-devel lrzsz freetype-devel libpng-devel -y
yum install geos geos-devel cairo-devel libXt-devel -y
yum install boost-devel libcurl libcurl-devel -y 
yum groupinstall development tools -y 
yum install lapack lapack-devel blas blas-devel -y
yum install java-1.7.0-openjdk-devel -y
wget -P /etc/yum.repos.d/ http://petersen.fedorapeople.org/pandoc-standalone/pandoc-standalone.repo
yum install pandoc pandoc-citeproc -y
yum install readline-devel -y

