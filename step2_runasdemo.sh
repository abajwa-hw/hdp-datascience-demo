set -e

#HOME_DIR=$1
export HOME_DIR=/home/demo
export PROJECT_DIR=$HOME_DIR/hdp-datascience-demo

export M2_HOME=/usr/share/maven/latest
export M2=$M2_HOME/bin
export PATH=$PATH:$M2

echo 'M2_HOME=/usr/share/maven/latest' >> ~/.bashrc
echo 'M2=$M2_HOME/bin' >> ~/.bashrc
echo 'PATH=$PATH:$M2' >> ~/.bashrc


#2.2 specific vars that need to be set
if [ -e /usr/hdp/2.2.0.0-2041/hadoop/bin/hdfs ]
then
	export HADOOP_HOME=/usr/hdp/2.2.0.0-2041/hadoop
	export HADOOP_VERSION=2.6.0.2.2.0.0-2041
	export HDP_VERSION=2.2
	export JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk.x86_64
	
	#export HADOOP_HOME=/usr/hdp/current/hadoop-client
	#export PYTHONPATH=/usr/lib/python2.6/site-packages
	#export JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk.x86_64
	#export YARN_CONF_DIR=/etc/hadoop/conf
	#export HADOOP_CONF_DIR=/etc/hadoop/conf
	#source /home/demo/pyenv/bin/activate
	#export SPARK_HOME=/home/demo/spark-1.2
	#export HIVE_HOME=/usr/hdp/current/hive-client
	
else
	export HADOOP_HOME=/usr/lib/hadoop
	export JDK_VER=`ls /usr/jdk64/`
	export JAVA_HOME=/usr/jdk64/$JDK_VER	
	export HDP_VERSION=2.1
fi

export PYTHONPATH=/usr/lib/python2.6/site-packages
export YARN_CONF_DIR=/etc/hadoop/conf
export HADOOP_CONF_DIR=/etc/hadoop/conf

echo "export HADOOP_HOME=$HADOOP_HOME" >> $HOME_DIR/.bashrc
echo "export HADOOP_VERSION=$HADOOP_VERSION" >> $HOME_DIR/.bashrc
echo "export PYTHONPATH=$PYTHONPATH" >> $HOME_DIR/.bashrc
echo "export JAVA_HOME=$JAVA_HOME"  >> $HOME_DIR/.bashrc 
echo "export YARN_CONF_DIR=/etc/hadoop/conf" >> ~/.bashrc
echo "export HADOOP_CONF_DIR=/etc/hadoop/conf" >> ~/.bashrc
echo "cd $HOME_DIR" >> $HOME_DIR/.bashrc


#install sqllite
echo "Installing SQLlite"
cd $HOME_DIR 
wget http://www.sqlite.org/2014/sqlite-autoconf-3080600.tar.gz
tar xvfz sqlite-autoconf-3080600.tar.gz 
cd sqlite-autoconf-3080600 
./configure --prefix=$HOME_DIR/.sqlite3 
make && make install

#install python
echo "Installing Python..."
cd $HOME_DIR 
wget https://www.python.org/ftp/python/2.7.8/Python-2.7.8.tar.xz 
xz -d Python-2.7.8.tar.xz && tar -xvf Python-2.7.8.tar 
cd Python-2.7.8 
#./configure --prefix=$HOME_DIR/.python LDFLAGS='-L$HOME_DIR/sqlite-autoconf-3080600/.libs' CPPFLAGS='-I$HOME_DIR/sqlite-autoconf-3080600/' 
./configure --prefix=$HOME_DIR/.python LDFLAGS='-L/home/demo/sqlite-autoconf-3080600/.libs' CPPFLAGS='-I/home/demo/sqlite-autoconf-3080600/' 
make && make altinstall

# Install Python’s package management: easy_install and pip
echo "Installing python pip..."
cd $HOME_DIR 
wget https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py 
.python/bin/python2.7 ez_setup.py 
.python/bin/easy_install-2.7 pip

# Install and activate VirtualEnv
echo "Installing python virtualenv..."
.python/bin/pip2.7 install virtualenv 
.python/bin/virtualenv pyenv
chmod +x ./pyenv/bin/activate 
source ./pyenv/bin/activate
echo "source $HOME_DIR/pyenv/bin/activate" >> $HOME_DIR/.bashrc


#Install data-science related Python package - this can take 10min
echo "Installing python packages: numpy scipy pandas scikit-learn..."
#pip install numpy scipy pandas scikit-learn rpy2
pip install numpy==1.9.0
pip install scipy==0.14.0
pip install pandas==0.14.1
pip install scikit-learn==0.15.1
pip install rpy2

#Install matplotlib (for graphics in Python)
cd $HOME_DIR
wget http://sourceforge.net/projects/freetype/files/freetype2/2.5.0/freetype-2.5.0.tar.gz
tar xvfz freetype-2.5.0.tar.gz


cd $HOME_DIR/freetype-2.5.0
sudo ./configure --prefix=/usr --disable-static && make
sudo make install 
sudo install -v -m755 -d /usr/share/doc/freetype-2.5.0 
sudo cp -v -R docs/* /usr/share/doc/freetype-2.5.0


cd $HOME_DIR
source ./pyenv/bin/activate

# Install ipython
easy_install ipython==2.3.0
sudo easy_install -U distribute
pip install matplotlib

#Install PYDOOP – package to enable Hadoop access from Python.
echo "Installing pydoop..."

if [ -e /usr/hdp/2.2.0.0-2041/hadoop/bin/hdfs ]
then
	git clone https://github.com/crs4/pydoop.git
	cd pydoop
	#update _hadoop2_jars method in ./pydoop/hadoop_utils.py
	mv $HOME_DIR/pydoop/pydoop/hadoop_utils.py $HOME_DIR/pydoop/pydoop/hadoop_utils.py.bak
	cp -f $PROJECT_DIR/setup/hadoop_utils_22.py $HOME_DIR/pydoop/pydoop/hadoop_utils.py
else

	wget http://sourceforge.net/projects/pydoop/files/Pydoop-0.12/pydoop-0.12.0.tar.gz 
	tar xzvf pydoop-0.12.0.tar.gz 
	cd pydoop-0.12.0

	#https://github.com/ZEMUSHKA/pydoop/commit/414a2e52390a873e4766633891190ffede937d90
	#vi pydoop/hadoop_utils.py 
	mv $HOME_DIR/pydoop-0.12.0/pydoop/hadoop_utils.py $HOME_DIR/pydoop-0.12.0/pydoop/hadoop_utils.py.bak
	cp -f $PROJECT_DIR/setup/hadoop_utils.py $HOME_DIR/pydoop-0.12.0/pydoop

	#https://github.com/ZEMUSHKA/pydoop/commit/e3d3378ae9921561f6c600c79364c2ad42ec206d
	#vi setup.py
	mv $HOME_DIR/pydoop-0.12.0/setup.py $HOME_DIR/pydoop-0.12.0/setup.py.bak
	cp -f $PROJECT_DIR/setup/setup.py $HOME_DIR/pydoop-0.12.0
fi

 
# build PyDoop 
python setup.py build 
python setup.py install --skip-build


#Setup default IPython notebook profile
pip install tornado pyzmq ipython pygments matplotlib jinja2 jsonschema
ipython profile create default

echo "c.IPKernelApp.pylab = 'inline'" >> $HOME_DIR/.ipython/profile_default/ipython_notebook_config.py
echo "c.NotebookApp.ip = '*' " >> $HOME_DIR/.ipython/profile_default/ipython_notebook_config.py
echo "c.NotebookApp.open_browser = False" >> $HOME_DIR/.ipython/profile_default/ipython_notebook_config.py
echo "c.NotebookApp.port = 9999" >> $HOME_DIR/.ipython/profile_default/ipython_notebook_config.py
echo "c.NotebookApp.tornado_settings = {'headers': {'Content-Security-Policy': '' } }" >> $HOME_DIR/.ipython/profile_default/ipython_notebook_config.py
echo "c.NotebookApp.webapp_settings = {'headers': {'X-Frame-Options': 'ALLOW-FROM all'}}" >> $HOME_DIR/.ipython/profile_default/ipython_notebook_config.py


echo "Downloading Spark..."
cd
if [ -e /usr/hdp/2.2.0.0-2041/hadoop/bin/hdfs ]
then

	#follow instructions from 2.2 Spark TP
	#wget http://public-repo-1.hortonworks.com/HDP-LABS/Projects/spark/1.2.0/spark-1.2.0.2.2.0.0-82-bin-2.6.0.2.2.0.0-2041.tgz
	#tar xvfz spark-1.2.0.2.2.0.0-82-bin-2.6.0.2.2.0.0-2041.tgz
	#export SPARK_HOME=$HOME_DIR/spark-1.2.0.2.2.0.0-82-bin-2.6.0.2.2.0.0-2041
	#echo "export SPARK_HOME=$HOME_DIR/spark-1.2.0.2.2.0.0-82-bin-2.6.0.2.2.0.0-2041" >> ~/.bashrc
	#git clone https://github.com/hortonworks/spark.git
	#git clone https://github.com/hortonworks/spark-native-yarn.git
	
	#download pre-built Spark 1.2 patched with SPARK-4923
	wget https://dl.dropboxusercontent.com/u/114020/spark-1.2.zip
	unzip spark-1.2.zip
	export SPARK_HOME=$HOME_DIR/spark-1.2
	echo "export SPARK_HOME=$HOME_DIR/spark-1.2" >> ~/.bashrc
		
	echo "spark.driver.extraJavaOptions -Dhdp.version=2.2.0.0-2041" >> $SPARK_HOME/conf/spark-defaults.conf 
	echo "spark.yarn.am.extraJavaOptions -Dhdp.version=2.2.0.0-2041" >> $SPARK_HOME/conf/spark-defaults.conf
	



else
	wget http://public-repo-1.hortonworks.com/HDP-LABS/Projects/spark/1.1.0/spark-1.1.0.2.1.5.0-702-bin-2.4.0.2.1.5.0-695.tgz
	tar xvfz spark-1.1.0.2.1.5.0-702-bin-2.4.0.2.1.5.0-695.tgz
	export SPARK_HOME=$HOME_DIR/spark-1.1.0.2.1.5.0-702-bin-2.4.0.2.1.5.0-695
	echo "export SPARK_HOME=$HOME_DIR/spark-1.1.0.2.1.5.0-702-bin-2.4.0.2.1.5.0-695" >> ~/.bashrc
fi

echo "Installing ISpark..."
cd $HOME_DIR
git clone https://github.com/tribbloid/ISpark
cd ISpark/
#Change spark version in ISpark/pom.xml from 1.1.1 to 1.2.1
cp pom.xml pom.xml.bak
sed -i "s/1.1.1/1.2.1/g" pom.xml

mvn package
source ../pyenv/bin/activate
ipython profile create spark


echo "import os" >> $HOME_DIR/.ipython/profile_spark/ipython_config.py
echo "SPARK_HOME = os.environ['SPARK_HOME']" >> $HOME_DIR/.ipython/profile_spark/ipython_config.py
echo "MASTER = 'yarn-client'" >> $HOME_DIR/.ipython/profile_spark/ipython_config.py
#echo 'c.KernelManager.kernel_cmd = [SPARK_HOME+"/bin/spark-submit",   "--master", MASTER,  "--class", "org.tribbloid.ispark.Main",   "--executor-memory", "2G", "$HOME_DIR/ISpark/core/target/ispark-core-assembly-0.1.0-SNAPSHOT.jar",   "--profile", "{connection_file}",  "--interp", "Spark",  "--parent"]' >> $HOME_DIR/.ipython/profile_spark/ipython_config.py
echo 'c.KernelManager.kernel_cmd = [SPARK_HOME+"/bin/spark-submit",   "--master", MASTER,  "--class", "org.tribbloid.ispark.Main",   "--executor-memory", "2G", "/home/demo/ISpark/core/target/ispark-core-assembly-0.1.0-SNAPSHOT.jar",   "--profile", "{connection_file}",  "--interp", "Spark",  "--parent"]' >> $HOME_DIR/.ipython/profile_spark/ipython_config.py
echo "c.NotebookApp.ip = '*' " >> $HOME_DIR/.ipython/profile_spark/ipython_config.py
echo "c.NotebookApp.open_browser = False" >> $HOME_DIR/.ipython/profile_spark/ipython_config.py
echo "c.NotebookApp.port = 9998" >> $HOME_DIR/.ipython/profile_spark/ipython_config.py
echo "c.NotebookApp.tornado_settings = {'headers': {'Content-Security-Policy': '' } }" >>  $HOME_DIR/.ipython/profile_spark/ipython_config.py
echo "c.NotebookApp.webapp_settings = {'headers': {'X-Frame-Options': 'ALLOW-FROM all'}}" >>  $HOME_DIR/.ipython/profile_spark/ipython_config.py



#configure ~/.ipython/profile_spark/startup/00-pyspark-setup.py
echo "import os" > $HOME_DIR/.ipython/profile_spark/startup/00-pyspark-setup.py
echo "import sys" >> $HOME_DIR/.ipython/profile_spark/startup/00-pyspark-setup.py
echo "spark_home = os.environ.get('SPARK_HOME', None) " >> $HOME_DIR/.ipython/profile_spark/startup/00-pyspark-setup.py
echo "sys.path.insert(0, os.path.join(spark_home, 'python')) " >> $HOME_DIR/.ipython/profile_spark/startup/00-pyspark-setup.py
echo "sys.path.insert(0, os.path.join(spark_home, 'python/lib/py4j-0.8.1-src.zip')) " >> $HOME_DIR/.ipython/profile_spark/startup/00-pyspark-setup.py
echo "execfile(os.path.join(spark_home, 'python/pyspark/shell.py'))" >> $HOME_DIR/.ipython/profile_spark/startup/00-pyspark-setup.py



#Install scalding for R demo
cd
git clone https://github.com/twitter/scalding.git
cd scalding/
git checkout master
sed -i "s/my.host.here/sandbox/g" /home/demo/scalding/scripts/scald.rb

#replace /home/demo/scalding/project/Build.scala
mv /home/demo/scalding/project/Build.scala /home/demo/scalding/project/Build.scala.orig
cp $PROJECT_DIR/setup/Build.scala /home/demo/scalding/project
./sbt update
set +e
./sbt assembly
set -e

export HADOOP_CMD=/usr/bin/hadoop 
#export HADOOP_STREAMING=/usr/lib/hadoop/contrib/streaming/hadoop-streaming.jar

echo "export HADOOP_CMD=/usr/bin/hadoop" >> ~/.bashrc
#echo "export HADOOP_STREAMING=/usr/lib/hadoop/contrib/streaming/hadoop-streaming.jar" >> ~/.bashrc

R CMD javareconf -e


cd $HOME_DIR
rm -f *.tgz *.gz *.zip *.tar

echo 'iPython notebook, pydoop, ISpark, R/Scalding setup complete'

