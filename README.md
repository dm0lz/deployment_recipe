# Setup deployment using postgres Nginx Puma #
#### First create a user deployer
````
adduser deployer
```
#### Then install following stuff
```
apt-get -y update && apt-get -y upgrade && apt-get -y install curl && apt-get -y install git-core && apt-get -y install python-software-properties && apt-get -y install locate
```
#### Then you need to allow passwordless sudo, add to visudo :
```
deployer ALL=NOPASSWD: ALL
%deployer ALL = (postgres) NOPASSWD: ALL
```
#### This will setup postgres, create db, create user setup nginx and puma
```
cap production deploy:setup
```
#### Then you need to uncomment in deploy.rb the appropriate lines and finally run :

```
cap production deploy
```
#### Troubleshooting
If you get error : bundle not found, ssh into server and run 
```
rvm use 2.2.2 --default
```
```
gem install bundler
```
