HOME_DIR=/home/demo

#add demo user and create home dir
useradd -m -d $HOME_DIR -G users demo 
echo "demo:demo" | chpasswd
cp /etc/sudoers /etc/sudoers.bak
echo "demo    ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

#add demo user and create home dir
useradd -m -d $HOME_DIR -G users demo 
echo "demo:demo" | chpasswd
cp /etc/sudoers /etc/sudoers.bak
echo "demo    ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

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


#install mvn as root
mkdir /usr/share/maven
cd /usr/share/maven
wget http://www.carfab.com/apachesoftware/maven/maven-3/3.2.2/binaries/apache-maven-3.2.2-bin.tar.gz
tar xvzf apache-maven-3.2.2-bin.tar.gz
ln -s /usr/share/maven/apache-maven-3.2.2/ /usr/share/maven/latest

