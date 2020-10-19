# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=// RAD Kernel // #StayRAD // 
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=dreamlte
device.name2=dream2lte
device.name3=
device.name4=
device.name5=
supported.versions=
supported.patchlevels=
'; } # end properties

# shell variables
block=/dev/block/platform/11120000.ufs/by-name/BOOT;
is_slot_device=0;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;


## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
set_perm_recursive 0 0 755 644 $ramdisk/*;
set_perm_recursive 0 0 750 750 $ramdisk/init* $ramdisk/sbin;

ui_print "Cleaning old Kernel leftovers...";
mount -o remount,rw /system;
rm -f $ramdisk/rz/scripts/40perf;
rm -f $ramdisk/rz/scripts/90userinit;
rm -f $ramdisk/init.spectrum.rc;
rm -f $ramdisk/init.spectrum.sh;
rm -f $ramdisk/sbin/rz_kernel.sh;
rm -f /system/bin/sysinit_cm;
rm -f /system/etc/init.d/30zram;
rm -f /system/etc/init.d/40perf;
rm -f /system/etc/init.d/90userinit;
rm -rf /data/rz_system;
rm -rf /system/rz_system;

ui_print "Initializing init.d support...";
mkdir /system/etc/init.d;
chmod 755 /system/etc/init.d;

## AnyKernel install
dump_boot;

# begin ramdisk changes

# init.rc
backup_file init.rc;
replace_string init.rc "cpuctl cpu,timer_slack" "mount cgroup none /dev/cpuctl cpu" "mount cgroup none /dev/cpuctl cpu,timer_slack";

# end ramdisk changes

write_boot;

ui_print "Done! - RAD-ified ur device!";

## end install

