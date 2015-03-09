export HDP_VER=`ls /usr/hdp/ | grep 2`

#for 2.2 onwards
if [ -e /usr/hdp/$HDP_VER/hadoop/bin/hdfs ]
then
	echo "Stopping Oozie..."
	su -l oozie -c "cd /var/log/oozie; /usr/hdp/$HDP_VER/oozie/bin/oozied.sh stop"

	echo "Stopping WebHCat..."
	su -l hcat -c "/usr/hdp/$HDP_VER/hive-hcatalog/sbin/webhcat_server.sh stop"

	echo "Stopping Hive..."
	ps aux | awk '{print $1,$2}' | grep hive | awk '{print $2}' | xargs kill >/dev/null 2>&1
else
	echo "Stopping Oozie..."
	su -l oozie -c "cd /var/log/oozie; /usr/hdp/current/oozie/bin/oozied.sh stop"

	echo "Stopping WebHCat..."
	su -l hcat -c "/usr/lib/hive-hcatalog/sbin/webhcat_server.sh stop"

	echo "Stopping Tez..."
	su -l tez -c "/usr/lib/tez/sbin/tez-daemon.sh stop ampoolservice"

	echo "Stopping Hive..."
	ps aux | awk '{print $1,$2}' | grep hive | awk '{print $2}' | xargs kill >/dev/null 2>&1
fi

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
yum install ruby -y

OS=$(lsb_release -si)
if [[ $OS == "RedHatEnterpriseServer" ]]
then
	echo "RedHat detected..manually installing R dependencies"
	wget http://mirror.centos.org/centos/6/os/x86_64/Packages/lapack-devel-3.2.1-4.el6.x86_64.rpm
	wget http://mirror.centos.org/centos/6/os/x86_64/Packages/blas-devel-3.2.1-4.el6.x86_64.rpm
	wget http://mirror.centos.org/centos/6/os/x86_64/Packages/texinfo-tex-4.13a-8.el6.x86_64.rpm
	wget http://mirror.centos.org/centos/6/os/x86_64/Packages/libicu-devel-4.2.1-9.1.el6_2.x86_64.rpm
	sudo yum localinstall -y *.rpm
	/bin/rm -f *.rpm
fi
 
#set up R
yum install R readline-devel python-devel -y
export HADOOP_CMD=/usr/bin/hadoop 
#export HADOOP_STREAMING=/usr/lib/hadoop/contrib/streaming/hadoop-streaming.jar
echo ". /usr/hdp/$HDP_VER/hadoop/libexec/hadoop-config.sh --config /etc/hadoop/conf" >> /etc/profile.d/r.sh

Rscript -e 'install.packages(c("Rcpp", "RJSONIO", "bitops", "digest", "functional", "reshape2", "stringr", "plyr", "caTools", "rJava", "Hmisc", "plyr", "dplyr", "devtools", "Rook", "R.methodsS3"), repos="http://cran.us.r-project.org");' 
Rscript -e 'install.packages(c("nnet", "randomForest", "rpart", "C50", "gbm", "e1071", "glmnet", "bnlearn", "cluster", "bigrf", "biclust","data.table"), repos="http://cran.us.r-project.org");'
Rscript -e 'install.packages(c("RJDBC"), repos="http://cran.us.r-project.org");'

wget http://goo.gl/Y5ytsm
mv Y5ytsm rmr2_3.3.0.tar
wget https://github.com/RevolutionAnalytics/rhdfs/blob/master/build/rhdfs_1.0.8.tar.gz?raw=true
mv rhdfs_1.0.8.tar.gz?raw=true rhdfs_1.0.8.tar.gz
R CMD INSTALL rmr2_3.3.0.tar
R CMD INSTALL rhdfs_1.0.8.tar.gz 
#R CMD javareconf -e

echo "Finished executing part 1"
