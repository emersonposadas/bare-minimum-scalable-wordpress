---
Requirements for provisioning:

* ansible-playbook
* terraform
* git

---

Setup:

* Put your AWS API keys under:
  - ~/.aws/config
```
[profile personal]
region = us-west-2
output = json
```

  - ~/.aws/credentials 
```
[personal]
aws_access_key_id = BLABLABLABLA
aws_secret_access_key = BLABLBLALBLALBLALBLBLLBA
```
---

Provisioning:

```
sh deploy.sh
```

---

Notes:

Monitoring memcached status:
```
watch 'echo stats | nc 127.0.0.1 11211'
```
httperf results:
3 conexiones por segundo un total de 1500 conexiones


```
$ httperf --server hkw-lb-id.us-west-2.elb.amazonaws.com --num-conn 1500 --num-cal 1 --rate 3 --timeout 5 --port 443 --ssl
httperf --timeout=5 --client=0/1 --server=hkw-lb-1527097002.us-west-2.elb.amazonaws.com --port=443 --uri=/ --rate=3 --send-buffer=4096 --recv-buffer=16384 --ssl --num-conns=1500 --num-calls=1
httperf: warning: open file limit > FD_SETSIZE; limiting max. # of open files to FD_SETSIZE
Maximum connect burst length: 1

Total: connections 1500 requests 1500 replies 1498 test-duration 500.978 s

Connection rate: 3.0 conn/s (334.0 ms/conn, <=13 concurrent connections)
Connection time [ms]: min 1283.2 avg 1379.4 max 5991.4 median 1330.5 stddev 387.4
Connection time [ms]: connect 515.7
Connection length [replies/conn]: 1.000

Request rate: 3.0 req/s (334.0 ms/req)
Request size [B]: 98.0

Reply rate [replies/s]: min 1.6 avg 3.0 max 4.0 stddev 0.2 (100 samples)
Reply time [ms]: response 500.6 transfer 363.1
Reply size [B]: header 418.0 content 55531.0 footer 2.0 (total 55951.0)
Reply status: 1xx=0 2xx=1498 3xx=0 4xx=0 5xx=0

CPU time [s]: user 243.68 system 257.26 (user 48.6% system 51.4% total 100.0%)
Net I/O: 163.7 KB/s (1.3*10^6 bps)

Errors: total 2 client-timo 2 socket-timo 0 connrefused 0 connreset 0
Errors: fd-unavail 0 addrunavail 0 ftab-full 0 other 0
```
---
Notes:
Connect to the DB: 
```
mysql -u id -h id.randomstring.us-west-2.rds.amazonaws.com -p id
```

---

Resources:

* https://www.concurrencylabs.com/blog/choose-your-aws-region-wisely/
* https://serverfault.com/questions/630022/what-is-the-recommended-cidr-when-creating-vpc-on-aws
* https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/hosting-wordpress.html
* https://stackoverflow.com/questions/2537486/create-dump-file-from-database-in-mysql
* https://www.digitalocean.com/community/tutorials/how-to-import-and-export-databases-in-mysql-or-mariadb
* https://stackoverflow.com/questions/13874836/how-to-use-1-database-connection-for-read-and-another-for-write-wordpress-mysql#13875300
* http://www.akamaras.com/linux/stress-test-your-web-server-with-httperf/
* https://dev.mysql.com/doc/mysql-repo-excerpt/5.7/en/linux-installation-yum-repo.html
* https://stackoverflow.com/questions/33374314/can-not-login-to-mysql-5-7-9-after-change-password
* https://help.dreamhost.com/hc/en-us/articles/214580498-How-do-I-change-the-WordPress-Site-URL-
* https://wordpress.stackexchange.com/questions/253245/wordpress-migration-getting-404-errors-only-home-page-works
* https://www.jeffgeerling.com/blog/2017/mount-aws-efs-filesystem-on-ec2-instance-ansible
* https://docs.bitnami.com/aws/apps/wordpress-pro/configuration/wordpress-aws-s3/
* https://medium.com/qbits/autoscaling-using-custom-metrics-5f977903bc45
