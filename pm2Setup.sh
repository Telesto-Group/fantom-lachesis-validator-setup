#!/bin/bash

PASSWORD=$1
VALIDATOR_WALLET_ADDRESS=$2
USERNAME=$(whoami)

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y nodejs npm
sudo npm i -g pm2

cd ~
echo $PASSWORD > password

echo '#!/bin/sh' > runNode.sh
echo "\$LACHESISPATH/build/lachesis --nousb --validator $VALIDATOR_WALLET_ADDRESS --unlock $VALIDATOR_WALLET_ADDRESS --password \$HOME/password" >> runNode.sh

chmod +x runNode.sh

echo "module.exports = { apps : [ { name: \"fantom\", script: \"/home/$USERNAME/runNode.sh\", exec_mode: \"fork\", exec_interpreter: \"bash\"} ] }" > ecosystem.config.js

pm2 start ./ecosystem.config.js
pm2 startup
sudo env PATH=$PATH:/usr/bin /usr/local/lib/node_modules/pm2/bin/pm2 startup systemd -u $USERNAME --hp /home/$USERNAME
pm2 save

