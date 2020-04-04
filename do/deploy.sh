#!/usr/bin/env bash

if [ "$1" == "prod" ] ; then
   if [ "$2" != "confirm" ] && [ "$3" != "confirm" ] ; then
      echo "Must add 'confirm' to deploy to prod"
      exit 1
   fi
   HOST="root@"
elif [ "$1" == "dev" ] ; then
   HOST="root@207.154.244.76"
else
   echo "Must specify environment (dev|prod)"
   exit 1
fi

FOLDER="app"
TAR="app.tar.gz"

if [ "$2" == "client" ] ; then
   scp client.js $HOST:$FOLDER
   scp testclient.js $HOST:$FOLDER
   scp clientold.js $HOST:$FOLDER
   exit 0
fi

if [ "$2" == "gotoB" ] ; then
   scp lib/gotoB.min.js $HOST:$FOLDER/lib
   exit 0
fi

if [ "$2" == "server" ] ; then
   scp server.js $HOST:$FOLDER
   ssh $HOST "cd $FOLDER && mg restart"
   exit 0
fi

if [ "$2" == "fast" ] ; then
   cd .. && tar --exclude="$FOLDER/*.swp" --exclude="$FOLDER/node_modules" --exclude="$FOLDER/.git" --exclude="$FOLDER/test" -czvf $TAR $FOLDER
else
   cd .. && tar --exclude="$FOLDER/*.swp" --exclude="$FOLDER/node_modules" -czvf $TAR $FOLDER
fi

scp $TAR $HOST:
ssh $HOST tar xzvf $TAR
echo "main = node server $1" | ssh $HOST "cat >> $FOLDER/mongroup.conf"
ssh $HOST "cd $FOLDER && npm i --no-save --production && mg restart"
ssh $HOST rm $TAR
rm $TAR