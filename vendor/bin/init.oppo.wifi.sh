#! /vendor/bin/sh

# Copyright (c) 2010-2013, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
#     * Neither the name of The Linux Foundation nor the names of its
#       contributors may be used to endorse or promote products derived
#       from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
# ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# This script will load and unload the wifi driver to put the wifi in
# in deep sleep mode so that there won't be voltage leakage.
# Loading/Unloading the driver only incase if the Wifi GUI is not going
# to Turn ON the Wifi. In the Script if the wlan driver status is
# ok(GUI loaded the driver) or loading(GUI is loading the driver) then
# the script won't do anything. Otherwise (GUI is not going to Turn On
# the Wifi) the script will load/unload the driver
# This script will get called after post bootup.

target="$1"
serialno="$2"

btsoc=""
#ifdef VENDOR_EDIT
#qiulei@PSW.CN.Wifi.Hardware,1065227 2018/06/18,
#Add for make bin Rom-update.
if [ -s /vendor/etc/wifi/bin_version ]; then
    system_version=`cat /vendor/etc/wifi/bin_version`
else
    system_version=1
fi

if [ -s /mnt/vendor/persist/bin_version ]; then
    persist_version=`cat /mnt/vendor/persist/bin_version`
else
    persist_version=1
fi

if [ -s /vendor/etc/wifi/regBin_version ]; then
    system_regBinversion=`cat /vendor/etc/wifi/regBin_version`
else
    system_regBinversion=1
fi

if [ -s /mnt/vendor/persist/regBin_version ]; then
    persist_regBinversion=`cat /mnt/vendor/persist/regBin_version`
else
    persist_regBinversion=1
fi

if [ ! -s /mnt/vendor/persist/regdb.bin  -o $system_regBinversion -gt $persist_regBinversion ]; then
    cp /vendor/etc/wifi/regdb.bin /mnt/vendor/persist/regdb.bin
    echo "$system_regBinversion" > /mnt/vendor/persist/regBin_version
    sync
fi
chmod 666 /mnt/vendor/persist/regdb.bin
chown system:wifi /mnt/vendor/persist/regdb.bin

vendorRegdb=`md5sum /vendor/etc/wifi/regdb.bin |cut -d" " -f1`
persistRegdb=`md5sum /mnt/vendor/persist/regdb.bin |cut -d" " -f1`
if [ x"$vendorRegdb" != x"$persistRegdb" ]; then
    cp /vendor/etc/wifi/regdb.bin /mnt/vendor/persist/regdb.bin
    echo "$system_regBinversion" > /mnt/vendor/persist/regBin_version
    sync
    chmod 666 /mnt/vendor/persist/regdb.bin
    chown system:wifi /mnt/vendor/persist/regdb.bin
    echo "regdb check"
fi

if [ ! -s /mnt/vendor/persist/bdwlan.bin  -o $system_version -gt $persist_version ]; then
    prj_version=`cat /proc/oppoVersion/prjName`
    case $prj_version in
       "20673")
        cp /vendor/etc/wifi/bdwlan_20673_id0.bin /mnt/vendor/persist/bdwlan_20673_id0.bin
        ;;
       "20671")
        cp /vendor/etc/wifi/bdwlan_20671_id0.bin /mnt/vendor/persist/bdwlan_20671_id0.bin
        ;;
       "20672")
        cp /vendor/etc/wifi/bdwlan_20672_id0.bin /mnt/vendor/persist/bdwlan_20672_id0.bin
        ;;
       "20675")
        cp /vendor/etc/wifi/bdwlan_20675_id0.bin /mnt/vendor/persist/bdwlan_20675_id0.bin
        ;;
       "20674")
        cp /vendor/etc/wifi/bdwlan_20674_id0.bin /mnt/vendor/persist/bdwlan_20674_id0.bin
        ;;
       "20670")
        cp /vendor/etc/wifi/bdwlan_20670_id0.bin /mnt/vendor/persist/bdwlan_20670_id0.bin
        ;;
       "2067D")
        cp /vendor/etc/wifi/bdwlan_2067D_id0.bin /mnt/vendor/persist/bdwlan_2067D_id0.bin
        ;;
       "2067C")
        cp /vendor/etc/wifi/bdwlan_2067C_id0.bin /mnt/vendor/persist/bdwlan_2067C_id0.bin
        ;;
       "2067A")
        cp /vendor/etc/wifi/bdwlan_2067A_id0.bin /mnt/vendor/persist/bdwlan_2067A_id0.bin
        ;;
       "20679")
        cp /vendor/etc/wifi/bdwlan_20679_id0.bin /mnt/vendor/persist/bdwlan_20679_id0.bin
        ;;
       "20676")
        cp /vendor/etc/wifi/bdwlan_20676_id0.bin /mnt/vendor/persist/bdwlan_20676_id0.bin
        ;;
       "20677")
        cp /vendor/etc/wifi/bdwlan_20677_id0.bin /mnt/vendor/persist/bdwlan_20677_id0.bin
        ;;
    esac
    echo "$system_version" > /mnt/vendor/persist/bin_version
fi

#Min.Yi@PSW.CN.Wifi.Hardware.1065227, 2017/11/21,
#Add for : bin for according project
prj_version=`cat /proc/oppoVersion/prjName`
pcb_version=`cat /proc/oppoVersion/pcbVersion`
case $prj_version in
       "20673" )
        cp /mnt/vendor/persist/bdwlan_20673_id0.bin /mnt/vendor/persist/bdwlan.bin
       ;;
       "20671" )
        cp /mnt/vendor/persist/bdwlan_20671_id0.bin /mnt/vendor/persist/bdwlan.bin
       ;;
       "20672" )
        cp /mnt/vendor/persist/bdwlan_20672_id0.bin /mnt/vendor/persist/bdwlan.bin
       ;;
       "20675" )
        cp /mnt/vendor/persist/bdwlan_20675_id0.bin /mnt/vendor/persist/bdwlan.bin
       ;;
       "20674" )
        cp /mnt/vendor/persist/bdwlan_20674_id0.bin /mnt/vendor/persist/bdwlan.bin
       ;;
       "20670" )
        cp /mnt/vendor/persist/bdwlan_20670_id0.bin /mnt/vendor/persist/bdwlan.bin
       ;;
       "2067D" )
        cp /mnt/vendor/persist/bdwlan_2067D_id0.bin /mnt/vendor/persist/bdwlan.bin
       ;;
       "2067C" )
        cp /mnt/vendor/persist/bdwlan_2067C_id0.bin /mnt/vendor/persist/bdwlan.bin
       ;;
       "2067A" )
        cp /mnt/vendor/persist/bdwlan_2067A_id0.bin /mnt/vendor/persist/bdwlan.bin
       ;;
       "20679" )
        cp /mnt/vendor/persist/bdwlan_20679_id0.bin /mnt/vendor/persist/bdwlan.bin
       ;;
       "20676" )
        cp /mnt/vendor/persist/bdwlan_20676_id0.bin /mnt/vendor/persist/bdwlan.bin
       ;;
       "20677" )
        cp /mnt/vendor/persist/bdwlan_20677_id0.bin /mnt/vendor/persist/bdwlan.bin
       ;;
esac

if [ x"$system_version" == x"$persist_version" ]; then
    bdf_file="bdwlan_"$prj_version"_id0.bin"
    vendor_bdf_file="/vendor/etc/wifi/"$bdf_file
    persist_bdf_file="/mnt/vendor/persist/"$bdf_file
    active_bdf_file="/mnt/vendor/persist/bdwlan.bin"

    vendor_bdf_md5=`md5sum $vendor_bdf_file | cut -d" " -f1`
    persist_bdf_md5=`md5sum $persist_bdf_file | cut -d" " -f1`
    active_bdf_md5=`md5sum $active_bdf_file | cut -d" " -f1`

    if [ x"$vendor_bdf_md5" != x"$persist_bdf_md5" -o x"$vendor_bdf_md5" != x"$active_bdf_md5" -o x"$persist_bdf_md5" != x"$active_bdf_md5" ]; then
        cp -f "$vendor_bdf_file" "$persist_bdf_file"
        cp -f "$vendor_bdf_file" "$active_bdf_file"
        sync
        echo "bdf check"
    fi
fi

chmod 666 /mnt/vendor/persist/bdwlan.bin
chown system:wifi /mnt/vendor/persist/bdwlan.bin



#Yuan.Huang@PSW.CN.Wifi.Network.internet.1065227, 2016/11/09,
#Add for make WCNSS_qcom_cfg.ini Rom-update.
if [ -s /vendor/etc/wifi/WCNSS_qcom_cfg.ini ]; then
    system_version=`head -1 /vendor/etc/wifi/WCNSS_qcom_cfg.ini | grep OppoVersion | cut -d= -f2`
    if [ "${system_version}x" = "x" ]; then
        system_version=1
    fi
else
    system_version=1
fi

#if WCNSS_qcom_cfg_version exists, dut upgrades from android 7.0
if [ -s /mnt/vendor/persist/WCNSS_qcom_cfg_version ]; then
    persist_version=0
    rm /mnt/vendor/persist/WCNSS_qcom_cfg_version
else
    if [ -s /mnt/vendor/persist/WCNSS_qcom_cfg.ini ]; then
        persist_version=`head -1 /mnt/vendor/persist/WCNSS_qcom_cfg.ini | grep OppoVersion | cut -d= -f2`
        if [ "${persist_version}x" = "x" ]; then
            persist_version=0
        fi
    else
        persist_version=0
    fi
fi

if [ ! -s /mnt/vendor/persist/WCNSS_qcom_cfg.ini -o $system_version -gt $persist_version ]; then
    cp /vendor/etc/wifi/WCNSS_qcom_cfg.ini \
            /mnt/vendor/persist/WCNSS_qcom_cfg.ini
    sync
    chown system:wifi /mnt/vendor/persist/WCNSS_qcom_cfg.ini
    chmod 666 /mnt/vendor/persist/WCNSS_qcom_cfg.ini
fi

persistini=`cat /mnt/vendor/persist/WCNSS_qcom_cfg.ini | grep -v "#" | grep -wc "END"`
if [ x"$persistini" = x"0" ]; then
    cp /vendor/etc/wifi/WCNSS_qcom_cfg.ini \
            /mnt/vendor/persist/WCNSS_qcom_cfg.ini
    sync
    chown system:wifi /mnt/vendor/persist/WCNSS_qcom_cfg.ini
    chmod 666 /mnt/vendor/persist/WCNSS_qcom_cfg.ini
    echo "ini check"
fi
#endif /* VENDOR_EDIT */
