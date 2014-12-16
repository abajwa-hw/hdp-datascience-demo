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
yarn.scheduler.minimum-allocation-mb = 2560
yarn.scheduler.maximum-allocation-mb = 10240
yarn.nodemanager.resource.memory-mb = 10240

- Pull latest code/scripts
```
git clone https://github.com/abajwa-hw/hdp-datascience-demo.git	
```