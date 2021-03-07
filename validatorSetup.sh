#!/bin/bash

# sets up a non root user, installs and runs lachesis.
# taken and modified from: https://docs.fantom.foundation/staking/how-to-run-a-validator-node

# ./validatorSetup.sh <username>
# ./validatorSetup.sh <username> <lachesis version>
# ./validatorSetup.sh myLachesisUser
# ./validatorSetup.sh myLachesisUser 0.7.0-rc.1

if [ $# -lt 1 ]; then
    echo "Please pass in at least a username to create"
    exit
fi

if [ $# -eq 2 ]; then
    LACHESIS_VERSION="$2"
else
    LACHESIS_VERSION='0.7.0-rc.1'
fi

USER=$1

echo $USER
echo $LACHESIS_VERSION

GO_VERSION='go1.13.3'

# Install required packages
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y zsh build-essential git wget tar

# Create a non-root user
if id "$USER" &>/dev/null; then
  echo "$USER user already exists"
  sudo rm -rf /home/$USER
else
  echo "creating user: $USER"
  sudo useradd -m $USER
fi

# Setup ssh
sudo mkdir -p /home/$USER/.ssh
sudo cp ~/.ssh/authorized_keys /home/$USER/.ssh/authorized_keys

# Setup permissions
sudo usermod -aG sudo $USER
sudo chown -R $USER:$USER /home/$USER/
sudo chmod 700 /home/$USER/.ssh
sudo chmod 644 /home/$USER/.ssh/authorized_keys
echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/dont-prompt-$USER-for-password

# Setup zsh for interaction later
sudo usermod --shell /bin/zsh $USER
sudo git clone https://github.com/robbyrussell/oh-my-zsh.git /home/$USER/.oh-my-zsh
sudo cp /home/$USER/.oh-my-zsh/templates/zshrc.zsh-template /home/$USER/.zshrc

# Define Paths
GOROOT=/usr/local/go
GOPATH=/home/$USER/go
LACHESISPATH=$GOPATH/src/github.com/Fantom-foundation
LACHESISURL=https://github.com/Fantom-foundation/go-lachesis.git
PATHS=$GOPATH/go/bin:$GOROOT/bin:$LACHESISPATH/build
ZSHRC=/home/$USER/.zshrc
BASHPROFILE=/home/$USER/.bash_profile

# Setup bash environment for running remaining setup
echo "export GOROOT=$GOROOT" | sudo tee -a $BASHPROFILE
echo "export GOPATH=$GOPATH" | sudo tee -a $BASHPROFILE
echo "export GO_VERSION=$GO_VERSION" | sudo tee -a $BASHPROFILE
echo "export LACHESISPATH=$LACHESISPATH" | sudo tee -a $BASHPROFILE
echo "export LACHESISURL=$LACHESISURL" | sudo tee -a $BASHPROFILE
echo "export LACHESIS_VERSION=$LACHESIS_VERSION" | sudo tee -a $BASHPROFILE
echo "export LACHESIS_BRANCH=$LACHESIS_BRANCH" | sudo tee -a $BASHPROFILE
echo "export PATH=$PATH:$PATHS" | sudo tee -a $BASHPROFILE

# Setup zsh environment for user
echo "export GOROOT=$GOROOT" | sudo tee -a $ZSHRC
echo "export GOPATH=$GOPATH" | sudo tee -a $ZSHRC
echo "export GO_VERSION=$GO_VERSION" | sudo tee -a $ZSHRC
echo "export LACHESISPATH=$LACHESISPATH" | sudo tee -a $ZSHRC
echo "export LACHESISURL=$LACHESISURL" | sudo tee -a $ZSHRC
echo "export LACHESIS_VERSION=$LACHESIS_VERSION" | sudo tee -a $ZSHRC
echo "export LACHESIS_BRANCH=$LACHESIS_BRANCH" | sudo tee -a $ZSHRC
echo "export PATH=$PATH:$PATHS" | sudo tee -a $ZSHRC

# Switch to new user to continue setup
sudo su - $USER --shell /bin/bash <<- 'EOT'
  # Check go installtion and install if needed
  INSTALLED_GO=$(go version)
  if [[ ! -z "$INSTALLED_GO" && "$INSTALLED_GO" == *"$GO_VERSION"* ]]
  then
    echo "go is already installed"
  else
    GO_FILE=$GO_VERSION.linux-amd64.tar.gz
    wget https://dl.google.com/go/$GO_FILE
    sudo rm -rf $GOROOT
    sudo tar -xf $GO_FILE -C /usr/local
  fi
  # Validate go version before moving on
  INSTALLED_GO=$(go version)
  echo $INSTALLED_GO
  if [[ ! -z "$INSTALLED_GO" && "$INSTALLED_GO" == *"$GO_VERSION"* ]]
  then
    # Check lachesis installtion and install if needed
    INSTALLED_LACHESIS=$(lachesis version)
    if [[ ! -z "$INSTALLED_LACHESIS" && "$INSTALLED_LACHESIS" =~ .*"$LACHESIS_VERSION".* ]]
    then
      echo "lachesis is already installed"
    else
      # Install Lachesis
      git clone $LACHESISURL $LACHESISPATH
      cd $LACHESISPATH
      git checkout tags/v$LACHESIS_VERSION
      make build
      cd build
      wget https://raw.githubusercontent.com/Fantom-foundation/lachesis_launch/master/releases/v$LACHESIS_VERSION/mainnet.toml
      cd ~
    fi
    # Validate lachesis version before moving on
    INSTALLED_LACHESIS=$(lachesis version)
    echo $INSTALLED_LACHESIS
    if [[ ! -z "$INSTALLED_LACHESIS" && "$INSTALLED_LACHESIS" =~ .*"$LACHESIS_VERSION".* ]]
    then
      echo "lachesis seems good. Leave this window going to sync the node and open a new ssh session with $USER"
      lachesis --nousb --exitwhensynced
    else
      echo "lachesis did not install for some reason"
    fi
  else
    echo "go did not install for some reason"
  fi
EOT

