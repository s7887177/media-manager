TEMP_SYNC_SOURCE=/tmp/.sync-sources
rm -rf $TEMP_SYNC_SOURCE && mkdir -p $TEMP_SYNC_SOURCE
ln -sfn "$PWD/src/docker/dist"/* $TEMP_SYNC_SOURCE
chmod -R +x "$PWD/src/scripts"
ln -sfn "$PWD/src/scripts/dist"/* $TEMP_SYNC_SOURCE
rsync -avL --delete $TEMP_SYNC_SOURCE/ dist/
rm -rf $TEMP_SYNC_SOURCE
