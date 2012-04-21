#!/bin/sh
UNPACKBOOTIMG="./bin-tools/unpackbootimg"
MKBOOTIMG="./bin-tools/mkbootimg"
INITSDIR="./initsdir".$$

INITRDTEMP="/tmp/initrdgz.$$"

BOOTIMGORG="./CE-STR_U2_01.1E.0/CG35.img"

USEKERNEL="$INITRDTEMP/CG35.img-zImage"
#USEKERNEL="./kernel-custom"

mkdir -p $INITSDIR
rm -rf $INITSDIR/*
mkdir -p $INITRDTEMP
$UNPACKBOOTIMG -i $BOOTIMGORG -o $INITRDTEMP

cd $INITSDIR
gunzip -c $INITRDTEMP/CG35.img-ramdisk.gz | cpio --no-absolute-filenames -i
cd ..

cp ./initrdreplace/* ./$INITSDIR/

#now repack

cd $INITSDIR
find | cpio -H newc -o | gzip > $INITRDTEMP/newinit.gz
cd ..

$MKBOOTIMG --kernel $USEKERNEL --ramdisk $INITRDTEMP/newinit.gz -o ./boot-custom.img


#now cleanup
rm -rf $INITSDIR
rm -rf $INITRDTEMP
