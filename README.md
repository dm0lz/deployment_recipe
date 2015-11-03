# README #

To allow passwordless sudo, add to visudo :
```
deployer ALL=NOPASSWD: ALL
%deployer ALL = (postgres) NOPASSWD: ALL
```
### Setup ###

```
cap production deploy:setup
```

Uncomment in deploy.rb the appropriate lines and finally execute :


```
cap production deploy
```
