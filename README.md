## Machine learning workshop demo

#### Predicting Flight Delays 

Every year approximately 20% of airline flights are delayed or cancelled, resulting in significant costs to both travelers and airlines. 
As our example use-case, we will build a supervised learning model that predicts airline delay from historical flight data and weather information.

For more info refer to below:
- http://hortonworks.com/blog/data-science-apacheh-hadoop-predicting-airline-delays/
- http://hortonworks.com/blog/data-science-hadoop-spark-scala-part-2/

##### Setup demo

These setup steps are only needed first time

- Download HDP 2.1 sandbox VM image (Hortonworks_Sandbox_2.1.ova) from [Hortonworks website](http://hortonworks.com/products/hortonworks-sandbox/)
- Import Hortonworks_Sandbox_2.1.ova into VMWare
- In the "Hard Disk" settings set disk size to 65GB
- Before starting the VM, open the .vmx file and set numvcpus = "4" and memsize = "16000". Then start the VM
```
vi /Users/<your userid>/Documents/Virtual Machines.localized/<your VMname>.vmwarevm 

```
- Find the IP address of the VM and add an entry into your machines hosts file e.g.
```
192.168.191.241 sandbox.hortonworks.com sandbox    
```
- Connect to the VM via SSH (password hadoop)
```
ssh root@sandbox.hortonworks.com
```
- Make the below YARN config changes via Ambari and restart YARN
```
yarn.scheduler.minimum-allocation-mb = 2560
yarn.scheduler.maximum-allocation-mb = 10240
yarn.nodemanager.resource.memory-mb = 10240
```
- In Ambari, shutdown unneeded services to save memory e.g. Oozie, Falcon, WebHCat, Ganglia, Nagios
- Create demo user
```
#add demo user and create home dir
useradd -m -d /home/demo -G users demo 
echo "demo:demo" | chpasswd
cp /etc/sudoers /etc/sudoers.bak
echo "demo    ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

```

As demo user, install needed software and setup the demo. This may run for 30+min
```
su demo
cd
#pull latest code and setup scripts
git clone https://github.com/abajwa-hw/hdp-datascience-demo.git	

#execute yum install steps that require root. Also bring down unnecessary services to save VM memory
sudo ./hdp-datascience-demo/step1_runasroot.sh

#install python etc and setup demo
./hdp-datascience-demo/step2_runasdemo.sh

```

To run the python demo execute below then point your browser to port where ipython notebook starts on and open airline_python.ipynb
e.g. http://sandbox.hortonworks.com:9999
```
ipython notebook
```

To run the Scala/Spark demo execute below then point your browser to port where ipython notebook starts on and open airline_spark.ipynb
e.g. http://sandbox.hortonworks.com:9999
```
ipython notebook --profile spark
```

![Image](../master/screenshots/ipython-notebook-home.png?raw=true)