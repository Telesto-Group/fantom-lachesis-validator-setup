if [ $# -eq 1 ]; then
    NEW_LACHESIS_VERSION="$1"
else
    echo "Please pass in a lachesis version"
    exit
fi

# Check lachesis installtion and install if needed
INSTALLED_LACHESIS=$(lachesis version)
if [[ ! -z "$INSTALLED_LACHESIS" && "$INSTALLED_LACHESIS" =~ .*"$NEW_LACHESIS_VERSION".* ]]
then
  echo "lachesis is already running desired version"
else
  echo "Updating lachesis from $LACHESIS_VERSION to $NEW_LACHESIS_VERSION"
  # Install Lachesis
  cd $LACHESISPATH
  git checkout tags/v$LACHESIS_VERSION
  make build
  cd ~
fi
sed -i "s,$LACHESIS_VERSION,$NEW_LACHESIS_VERSION," $HOME/.zshrc
# Validate lachesis version before moving on
INSTALLED_LACHESIS=$(lachesis version)
echo $INSTALLED_LACHESIS
if [[ ! -z "$INSTALLED_LACHESIS" && "$INSTALLED_LACHESIS" =~ .*"$LACHESIS_VERSION".* ]]
then
  echo "lachesis updated to $LACHESIS_VERSION.  Go ahead and start your node"
else
  echo "lachesis did not update correctly for some reason. You're in trouble."
fi
