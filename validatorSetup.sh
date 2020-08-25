#!/bin/bash

# sets up a non root user, installs and runs lachesis.
# taken and modified from: https://fantom.foundation/how-to-set-up-a-fantom-validator/

# ./validatorSetup.sh <username>
# ./validatorSetup.sh myLachesisUser

if [ $# -ne 1 ]; 
    then echo "Please pass in a username to create"
    exit
fi

USER=$1

GO_VERSION='go1.13.3'
LACHESIS_VERSION='0.7.0-rc.1'
LACHESIS_BRANCH='lachesis-v7rc1'

GOROOT=/usr/local/go
GOPATH=/home/$USER/go
LACHESISPATH=$GOPATH/Fantom-foundations/go-lachesis
PATHS=$GOPATH/go/bin:$GOROOT/bin:$LACHESISPATH/build

ZSHRC=/home/$USER/.zshrc
BASHPROFILE=/home/$USER/.bash_profile

# Install required packages
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y zsh build-essential git wget tar

# Create a non-root user
if id "$USER" &>/dev/null; then
  echo "$USER user already exists"
  sudo rm -rf /home/$USER
else
  sudo useradd -m $USER
fi

# Setup ssh
sudo mkdir -p /home/$USER/.ssh
sudo cp ~/.ssh/authorized_keys /home/$USER/.ssh/authorized_keys

# Setup bash for running remaining setup
echo "export GOROOT=$GOROOT" | sudo tee -a $BASHPROFILE
echo "export GOPATH=$GOPATH" | sudo tee -a $BASHPROFILE
echo "export GO_VERSION=$GO_VERSION" | sudo tee -a $BASHPROFILE
echo "export LACHESISPATH=$LACHESISPATH" | sudo tee -a $BASHPROFILE
echo "export LACHESIS_VERSION=$LACHESIS_VERSION" | sudo tee -a $BASHPROFILE
echo "export LACHESIS_BRANCH=$LACHESIS_BRANCH" | sudo tee -a $BASHPROFILE
echo "export PATH=$PATH:$PATHS" | sudo tee -a $BASHPROFILE


# Setup zsh for interaction later
sudo usermod --shell /bin/zsh $USER

sudo git clone https://github.com/robbyrussell/oh-my-zsh.git /home/$USER/.oh-my-zsh
sudo cp /home/$USER/.oh-my-zsh/templates/zshrc.zsh-template /home/$USER/.zshrc

echo "export GOROOT=$GOROOT" | sudo tee -a $ZSHRC
echo "export GOPATH=$GOPATH" | sudo tee -a $ZSHRC
echo "export GO_VERSION=$GO_VERSION" | sudo tee -a $ZSHRC
echo "export LACHESISPATH=$LACHESISPATH" | sudo tee -a $ZSHRC
echo "export LACHESIS_VERSION=$LACHESIS_VERSION" | sudo tee -a $ZSHRC
echo "export LACHESIS_BRANCH=$LACHESIS_BRANCH" | sudo tee -a $ZSHRC
echo "export PATH=$PATH:$PATHS" | sudo tee -a $ZSHRC

# Setup permissions
sudo usermod -aG sudo $USER
sudo chown -R $USER:$USER /home/$USER/
sudo chmod 700 /home/$USER/.ssh
sudo chmod 644 /home/$USER/.ssh/authorized_keys
echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/dont-prompt-$USER-for-password


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
    sudo rm -rf /usr/local/go
    sudo tar -xvf $GO_FILE
    sudo mv go /usr/local
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
      git clone https://github.com/Fantom-foundation/go-lachesis.git $LACHESISPATH
      cd $LACHESISPATH
      git checkout tags/v$LACHESIS_VERSION -b $LACHESIS_BRANCH
      make build
      cd ~
    fi
    # Validate lachesis version before moving on
    INSTALLED_LACHESIS=$(lachesis version)
    echo $INSTALLED_LACHESIS
    if [[ ! -z "$INSTALLED_LACHESIS" && "$INSTALLED_LACHESIS" =~ .*"$LACHESIS_VERSION".* ]]
    then
      echo "lachesis seems good. Leave this window going and open a new ssh session with $USER"
      lachesis --nousb
    else
      echo "lachesis did not install for some reason"
    fi
  else
    echo "go did not install for some reason"
  fi
EOT

