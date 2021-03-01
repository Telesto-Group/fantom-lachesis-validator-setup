NEWLACHESISPATH=$GOPATH/src/github.com/Fantom-foundation
mkdir -p $NEWLACHESISPATH
cp -a $LACHESISPATH $NEWLACHESISPATH
rm -rf $GOPATH/Fantom-foundations

sed -i "s,$LACHESISPATH,$NEWLACHESISPATH/go-lachesis," $HOME/.zshrc

source $HOME/.zshrc
