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
