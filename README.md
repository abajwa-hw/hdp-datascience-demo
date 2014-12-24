## Machine learning workshop demo
This demo is part of a 'Machine Learning with Hadoop' webinar.
The webinar recording and slides are available at http://hortonworks.com/partners/learn

#### Predicting Flight Delays 
Demo scenario:
Every year approximately 20% of airline flights are delayed or cancelled, resulting in significant costs to both travelers and airlines. 
As our example use-case, we will build a supervised learning model that predicts airline delay from historical flight data and weather information.
Currently there are two versions of this demo available: one with Python/Scikit-learn and one with Spark/Scala (the R demo is being developed)
More details can be found on the below Hortonworks blog posts:
- http://hortonworks.com/blog/data-science-apacheh-hadoop-predicting-airline-delays/
- http://hortonworks.com/blog/data-science-hadoop-spark-scala-part-2/

To get a better understanding of machine learning and how the models below work:
- https://www.coursera.org/course/ml

##### Setup VM - Option 1: Import prebuilt VM
There is a prebuilt VM with the demo running on a HDP 2.1 sandbox [here](https://dl.dropboxusercontent.com/u/114020/Hortonworks_Sandbox_2.1_MLdemo.ova) 

You can simply import it into VMware Fusion, start the VM and follow the instructions in the readme under /root. You do not need to follow the rest of the instructions below.

A version of the demo VM running on HDP 2.2 sandbox is currently being worked on 

##### Setup VM - Option 2: Setup demo on HDP 2.1 sandbox VM

These setup steps are only needed first time

- Download HDP 2.1 sandbox VM image (Hortonworks_Sandbox_2.1.ova) from [Hortonworks website](http://hortonworks.com/products/hortonworks-sandbox/)
- Import Hortonworks_Sandbox_2.1.ova into VMWare
- Now follow demo setup instructions below

##### Setup VM - Option 3: Setup demo on HDP 2.2 sandbox VM - only python demo supported for now

- Download HDP 2.2 sandbox VM image (Sandbox_HDP_2.2_VMware.ova) from [Hortonworks website](http://hortonworks.com/products/hortonworks-sandbox/)
- Import Sandbox_HDP_2.2_VMware.ova into VMWare
- Make the below Pig config changes via Ambari to enable Tez and restart Pig
```
#exectype=mapreduce
exectype=tez
```
- Now follow demo setup instructions below

##### Demo setup instructions

- Make the below YARN config changes via Ambari and restart YARN
```
yarn.nodemanager.resource.memory-mb = 9216 
yarn.scheduler.minimum-allocation-mb = 1536
yarn.scheduler.maximum-allocation-mb = 9216
```

- In the "Hard Disk" settings set disk size to 65GB
- Before starting the VM, open the .vmx file and set numvcpus = "4" and memsize = "16000". Then start the VM
```
#e.g. if you are using VMWare Fusion on OSX 
vi "/Users/<your userid>/Documents/Virtual Machines.localized/<your VMname>.vmwarevm/<your VMname>.vmx"
```
- Find the IP address of the VM and add an entry into your machines hosts file e.g.
```
192.168.191.241 sandbox.hortonworks.com sandbox    
```
- Connect to the VM via SSH (password hadoop) and start Ambari server
```
ssh root@sandbox.hortonworks.com
/root/start_ambari.sh
```

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
sudo /home/demo/hdp-datascience-demo/step1_runasroot.sh

#install python etc and setup demo
/home/demo/hdp-datascience-demo/step2_runasdemo.sh

```

##### Launch demo

To run the python demo execute below then point your browser to port where ipython notebook starts on and open airline_python.ipynb (on HDP 2.1) or airline_python-2.2.ipynb (on HDP 2.2)
e.g. http://sandbox.hortonworks.com:9999
```

source ~/.bashrc
cd /home/demo/hdp-datascience-demo/demo
ipython notebook
```

To run the Scala/Spark demo execute below then point your browser to port where ipython notebook starts on and open airline_spark.ipynb
e.g. http://sandbox.hortonworks.com:9999
```
source ~/.bashrc
cd /home/demo/hdp-datascience-demo/demo
ipython notebook --profile spark
```

![Image](../master/screenshots/ipython-notebook-home.png?raw=true)