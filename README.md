# fantom-lachesis-validator-setup

## 1. Setup an AWS node
- [current EC2 recommendations](https://docs.fantom.foundation/staking/how-to-run-a-validator-node#validator-parameters)

## 2. Create a non-root user and begin Lachesis sync
 - from your AWS ec2 node, as the default user, run:
 - be sure to give a user name in place of &lt;username>
```
curl https://raw.githubusercontent.com/mhetzel/fantom-lachesis-validator-setup/master/validatorSetup.sh | bash -s <username>
```

## 3. Create a validator wallet and validator

## Notes
[Run commands in the background](https://www.computerhope.com/unix/unohup.htm)

[Lachesis 0.7.0-rc.1 Info](https://github.com/Fantom-foundation/go-lachesis/tree/v0.7.0-rc.1)

## migrate paths
```
curl https://raw.githubusercontent.com/mhetzel/fantom-lachesis-validator-setup/master/migrate.sh | zsh
source .zshrc
```

## upgrade lachesis version
 - from your AWS ec2 node, as the non root user, run:
 - be sure to give a [valid version](https://github.com/Fantom-foundation/go-lachesis/releases) of lachesis in place of &lt;version>
```
curl https://raw.githubusercontent.com/mhetzel/fantom-lachesis-validator-setup/master/upgrade.sh | bash -s <version.
```
