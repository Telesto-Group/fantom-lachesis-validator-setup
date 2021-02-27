#!/bin/bash

GO_VERSION='go1.13.3'
LACHESIS_VERSION='0.7.0-rc.1'
LACHESIS_BRANCH='lachesis-v7rc1'
GOROOT=/usr/local/go
GOPATH=$HOME/go
LACHESISPATH=$GOPATH/src/github.com/Fantom-foundation
PATHS=$GOPATH/go/bin:$GOROOT/bin:$LACHESISPATH/build
mkdir -p $LACHESISPATH
cp -a $GOPATH/Fantom-foundations/go-lachesis $LACHESISPATH

ZSHRC=$HOME/.zshrc

rm $HOME/.zshrc

echo "export GOROOT=$GOROOT" | sudo tee -a $ZSHRC
echo "export GOPATH=$GOPATH" | sudo tee -a $ZSHRC
echo "export GO_VERSION=$GO_VERSION" | sudo tee -a $ZSHRC
echo "export LACHESISPATH=$LACHESISPATH" | sudo tee -a $ZSHRC
echo "export LACHESIS_VERSION=$LACHESIS_VERSION" | sudo tee -a $ZSHRC
echo "export LACHESIS_BRANCH=$LACHESIS_BRANCH" | sudo tee -a $ZSHRC
echo "export PATH=$PATH:$PATHS" | sudo tee -a $ZSHRC

