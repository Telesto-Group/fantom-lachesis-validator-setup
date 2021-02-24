# fantom-lachesis-validator-setup

## 1. Setup an AWS node
- Ubuntu Server 18.04 LTS (64-bit)
- At least an m5.large General Purpose Instance with 2 CPU and 8GB of memory.
- At least 250GB of disk space.
- Open up port 22 for SSH, as well as port 5050 for both TCP and UDP traffic.

## 2. Create a non-root user and begin Lachesis sync
 - from your AWS ec2 node, as the default user, run:
 - be sure to give a user name in place of &lt;username>
```
curl https://raw.githubusercontent.com/mhetzel/fantom-lachesis-validator-setup/master/validatorSetup.sh | bash -s <username>
```

## 3. Create a validator wallet and validator

## 4. Optionally setup a pm2 services to run Lachesis
### This is not recommended.
- from your AWS ec2 node as your new non-root user run:
- be sure to give your account password in place of &lt;password> and your wallet address in place of &lt;walletaddress>
```
curl https://raw.githubusercontent.com/mhetzel/fantom-lachesis-validator-setup/master/pm2Setup.sh | bash -s <password> <walletaddress>
```


## Notes
[Run commands in the background](https://www.computerhope.com/unix/unohup.htm)
[pm2 info](https://pm2.keymetrics.io/docs/usage/quick-start/)
