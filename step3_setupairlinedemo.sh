export HOME_DIR=/home/demo
export PROJECT_DIR=$HOME_DIR/hdp-datascience-demo

#create HDFS dirs
sudo -u hdfs hadoop fs -mkdir /user/demo
sudo -u hdfs hadoop fs -chown demo:demo /user/demo
hadoop fs -mkdir /user/demo/airline
hadoop fs -mkdir /user/demo/airline/delay
hadoop fs -mkdir /user/demo/airline/weather

#Get the data files and upload to HDFS
echo "Downloading delay data to HDFS...."
cd $PROJECT_DIR/demo
mkdir airline
cd airline
mkdir delay
cd delay
wget http://stat-computing.org/dataexpo/2009/2007.csv.bz2
bzip2 -d 2007.csv.bz2
wget http://stat-computing.org/dataexpo/2009/2008.csv.bz2
bzip2 -d 2008.csv.bz2
hadoop fs -put $PROJECT_DIR/demo/airline/delay/*.csv /user/demo/airline/delay
#delete copy of data from local FS to save space
rm $PROJECT_DIR/demo/airline/delay/*.csv

echo "Downloading weather data to HDFS...."
cd $PROJECT_DIR/demo/airline
mkdir weather
cd  $PROJECT_DIR/demo/airline/weather
wget ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/by_year/2007.csv.gz
gunzip -d 2007.csv.gz
wget ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/by_year/2008.csv.gz
gunzip -d 2008.csv.gz
hadoop fs -put $PROJECT_DIR/demo/airline/weather/*.csv /user/demo/airline/weather
#delete copy of data from local FS to save space
rm $PROJECT_DIR/demo/airline/weather/*.csv

cd $PROJECT_DIR/demo

echo "The demo setup is complete"
echo "To run the python demo execute"
echo "source ~/.bashrc"
echo "cd /home/demo/hdp-datascience-demo/demo"
echo "ipython notebook"
echo "Then navigate to http://sandbox.hortonworks.com:<port>"
echo ""
echo "To run the Scala/Spark demo execute"
echo "source ~/.bashrc"
echo "cd /home/demo/hdp-datascience-demo/demo"
echo "ipython notebook --profile spark"
echo "Then navigate to http://sandbox.hortonworks.com:<port>"

