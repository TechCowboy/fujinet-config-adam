#!/bin/bash
#
# This script creates a PRODOS 2.4.2 disk, and adds BITSY to it
# to create bootable disk with menu.
# Use add-file.sh to add additional files once boot disk is created.

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ $# -ne 2 ] ; then
  echo "Usage: $(basename $0) name.po VOLUMENAME"
  echo "Creates name.po and places BITSY.BOOT files on it, ready to copy applications onto."
  exit 1
fi

JAVA_LOCATION=$(which java)
if [ $? -eq 1 ]; then
  echo "Unable to find java on command line. You must have a working java at least version 11 to use this script."
  exit 1
fi

DISKNAME=$1
# Convert underscores and hyphens to fullstops in the name, as they aren't allowed. Maybe others!
VOLUMENAME=$(echo $2 | tr '_-' '.')
if [ -f $DISKNAME ] ; then
  rm $DISKNAME
fi

${SCRIPT_DIR}/get-binaries.sh -p

AC="java -jar ${SCRIPT_DIR}/AppleCommander-ac-1.8.0.jar"
ACX="java -jar ${SCRIPT_DIR}/AppleCommander-acx-1.8.0.jar"
SRC_PRODOS=${SCRIPT_DIR}/ProDOS_2_4_2.dsk

export ACX_DISK_NAME=${DISKNAME}

${ACX} create --prodos -f ${SRC_PRODOS}
${ACX} rm -f BASIC.SYSTEM
${ACX} copy --from ${SRC_PRODOS} BITSY.BOOT QUIT.SYSTEM BASIC.SYSTEM
${ACX} rename-disk ${VOLUMENAME}