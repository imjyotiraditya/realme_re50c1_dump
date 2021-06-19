#! /system/bin/sh
#***********************************************************
#** Copyright (C), 2008-2016, OPPO Mobile Comm Corp., Ltd.
#** VENDOR_EDIT
#**
#** Version: 1.0
#** Date : 2019/06/25
#** Author: Liangwen.Ke@PSW.CN.BT.Basic.Customize.2120948
#** Add  for supporting QC firmware update by sau_res
#**
#** ---------------------Revision History: ---------------------
#**  <author>    <data>       <version >       <desc>
#**  Liangwen.Ke 2019.6.25      1.0            build this module
#****************************************************************/

config="$1"

saufwdir="/data/oppo/common/sau_res/res/SAU-AUTO_LOAD_FW-10/"
pushfwdir="/data/vendor/bluetooth/fw/"
pushdatadir="data/misc/bluedroid/"

# cp bt sau file to data/vendor/bluetooth dir
function btfirmwareupdate() {

    if [ -f ${saufwdir}/cmbtfw12.tlv ]; then
        cp  ${saufwdir}/cmbtfw12.tlv  ${pushfwdir}
        chown bluetooth:bluetooth ${pushfwdir}/cmbtfw12.tlv
        chmod 0440 bluetooth:bluetooth ${pushfwdir}/cmbtfw12.tlv
    fi

    if [ -f ${saufwdir}/cmnv12.bin ]; then
        cp  ${saufwdir}/cmnv12.bin  ${pushfwdir}
        chown bluetooth:bluetooth ${pushfwdir}/cmnv12.bin
        chmod 0440 bluetooth:bluetooth ${pushfwdir}/cmnv12.bin
    fi

    if [ -f ${saufwdir}/cmbtfw12.ver ]; then
        cp  ${saufwdir}/cmbtfw12.ver  ${pushfwdir}
        cp  ${saufwdir}/cmbtfw12.ver  ${pushdatadir}
        chown bluetooth:bluetooth ${pushfwdir}/cmbtfw12.ver
        chown bluetooth:bluetooth ${pushdatadir}/cmbtfw12.ver
        chmod 0440 bluetooth:bluetooth ${pushfwdir}/cmbtfw12.ver
        chmod 0440 bluetooth:bluetooth ${pushdatadir}/cmbtfw12.ver
    fi
}

# delete all bt sau file
function btfirmwaredelete() {

    if [ -f ${saufwdir}/cmbtfw12.tlv ]; then
        rm -rf  ${saufwdir}/cmbtfw12.tlv
    fi

    if [ -f ${pushfwdir}/cmbtfw12.tlv ]; then
        rm -rf  ${pushfwdir}/cmbtfw12.tlv
    fi

    if [ -f ${saufwdir}/cmnv12.bin ]; then
        rm -rf  ${saufwdir}/cmnv12.bin
    fi

    if [ -f ${pushfwdir}/cmnv12.bin ]; then
        rm -rf  ${pushfwdir}/cmnv12.bin
    fi

    if [ -f ${saufwdir}/cmbtfw12.ver ]; then
        rm -rf  ${saufwdir}/cmbtfw12.ver
    fi

    if [ -f ${pushfwdir}/cmbtfw12.ver ]; then
        rm -rf  ${pushfwdir}/cmbtfw12.ver
    fi

    if [ -f ${pushdatadir}/cmbtfw12.ver ]; then
        rm -rf  ${pushdatadir}/cmbtfw12.ver
    fi
}

case "$config" in
    "btfirmwareupdate")
        btfirmwareupdate
    ;;

    "btfirmwaredelete")
        btfirmwaredelete
    ;;
esac
