#d_spacewalk
Spacewalk 2.4 in a CentOS6 container || Spacewalk settings will survive container restart, but if you remove the container all the data will be lost!
### Run ###
```
docker run -dh spacewalk --name spacewalk --privileged -p 80:80 -p 443:443 -p 5222:5222 -p 5269:5269 --restart=unless-stopped csabakollar/spacewalk
```
### Build locally and run ###
```
git clone https://github.com/csabakollar/d_spacewalk /opt/d_spacewalk
docker build --rm -t spacewalk /opt/d_spacewalk
docker run -dh spacewalk --name spacewalk --privileged -p 80:80 -p 443:443 -p 5222:5222 -p 5269:5269 --restart=unless-stopped spacewalk
```
### Docker-machine ###
The following command only works if you have only one docker vm running, if you have more, hopefully you'll know the IP of the docker-engine you started the container
```
docker-machine ip $(docker-machine ls |grep Run|awk '{print $1}')
192.168.99.100
```
In this case: https://192.168.99.100
### boot2docker ###
```
boot2docker ip
192.168.99.101
```
Or if you run the container on a server, just check the server's IP then use https://_servers_ip_
### Recommended reading ###
* https://fedorahosted.org/spacewalk/wiki/RegisteringClients
* https://fedorahosted.org/spacewalk/wiki/UploadFedoraContent
* https://fedorahosted.org/spacewalk/wiki/SpacewalkBackup
* http://cefs.steve-meier.de/

### Erratas ###
!!! Container already contains the errata-import.pl from http://cefs.steve-meier.de/ in /opt
### Sample errata_updater.sh script ###
Enter to the container
```
docker exec -it spacewalk bash
```
The run
```
cat > /opt/errata_updater.sh << EOF
#!/bin/bash
export SPACEWALK_USER='admin'
export SPACEWALK_PASS='supersecret'
wget -O /tmp/latest_errata.xml http://cefs.steve-meier.de/errata.latest.xml
/opt/errata-import.pl --server localhost --errata /tmp/latest_errata.xml --publish 
EOF
```
Make it executable
```
chmod +x /opt/errata_updater.sh
```
Put it in crontab (run daily once at midnight):
```
0 0 * * * /opt/errata_updater.sh > /var/log/errata_updater.log 2>/var/log/errata_updater.err
```
### Creating some common channels ###
Enter to the container
```
docker exec -it spacewalk bash
```
then run
```
spacewalk-common-channels spacewalk-common-channels -u admin -p supersecret -a i386,x86_64 'centos5*'
spacewalk-common-channels spacewalk-common-channels -u admin -p supersecret -a i386,x86_64 'centos6*'
spacewalk-common-channels spacewalk-common-channels -u admin -p supersecret -a i386,x86_64 'centos7*'
```
After this, you just create activation keys and set the synchronization of channels in:

```Channels -> Manage Software Channels -> pick a channel -> Repositories -> Sync```
### Thanks to ###
Big thanks to Yongbok Kim @ https://github.com/ruo91/ for the inspiration of Dockerfile
