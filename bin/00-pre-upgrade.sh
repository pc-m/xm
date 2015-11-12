#!/bin/sh
# post-stop hook for xivo-upgrade to umount all mount directories to avoid upgrading a temporary dir.

echo -n 'Unmounting all dev versions'
for mp in $(mount | grep xivo | awk '{ print $3 }')
do
    umount $mp
    echo -n '.'
done
echo 'done'
