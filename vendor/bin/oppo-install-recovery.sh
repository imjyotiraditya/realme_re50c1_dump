#!/system/bin/sh
if ! applypatch --check EMMC:/dev/block/bootdevice/by-name/recovery:100663296:79270868f2797db8d3346a26175ea5d23d72e249; then
  applypatch  \
          --patch /vendor/recovery-from-boot.p \
          --source EMMC:/dev/block/bootdevice/by-name/boot:100663296:85743cf020ac0d6479daa96e363a18f36279b3f1 \
          --target EMMC:/dev/block/bootdevice/by-name/recovery:100663296:79270868f2797db8d3346a26175ea5d23d72e249 && \
      log -t recovery "Installing new oppo recovery image: succeeded" && \
      setprop ro.recovery.updated true || \
      log -t recovery "Installing new oppo recovery image: failed" && \
      setprop ro.recovery.updated false
else
  log -t recovery "Recovery image already installed"
  setprop ro.recovery.updated true
fi
