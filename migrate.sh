#!/bin/bash

GOROOT=/usr/local/go
GOPATH=$HOME/go
LACHESISPATH=$GOPATH/src/github.com/Fantom-foundation
PATHS=$GOPATH/go/bin:$GOROOT/bin:$LACHESISPATH/build
mkdir -p $LACHESISPATH
cp -a $GOPATH/Fantom-foundations/go-lachesis $LACHESISPATH
rm -rf $GOPATH/Fantom-foundations

ZSHRC=$HOME/.zshrc

echo "export LACHESISPATH=$LACHESISPATH" | sudo tee -a $ZSHRC
echo "export PATH=$PATH:$PATHS" | sudo tee -a $ZSHRC
