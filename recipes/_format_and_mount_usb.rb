# Make sure it's unmounted before we possibly format it
current_usb_mount = %x{cat /proc/mounts  | grep #{node['ii-usb']['target-device']}1 | cut -f 2 -d\\ }.strip

if not current_usb_mount.empty?
  # go ahead and use the current mount point for this run
  node.override['ii-usb']['target-mountpoint'] = current_usb_mount

  mount current_usb_mount do
    # don't unmount if we don't need to format
    not_if "blkid -s LABEL #{node['ii-usb']['target-device']}1 | grep #{node['ii-usb']['volume-name']}"
    device "#{node['ii-usb']['target-device']}1"
    action :umount
  end

end

bash "partition and format #{node['ii-usb']['target-device']}" do
  # don't format if we already have the correct volume name
  not_if "blkid -s LABEL #{node['ii-usb']['target-device']}1 | grep #{node['ii-usb']['volume-name']}"
  code <<-eoc
    parted -s ${USB} mklabel msdos 
    parted -s -- ${USB} mkpart primary fat32 2 #{node['ii-usb']['partition-size']}
    # the rest of the USB is for persistent
    parted -s -- ${USB} mkpart primary ext3 #{node['ii-usb']['partition-size']} -1
    parted -s -- ${USB} set 1 boot on
    mkfs.vfat -n '#{node['ii-usb']['volume-name']}' ${USB}1
    mkfs.ext3 -m 0 -b 4096 -L casper-rw ${USB}2
  eoc
  environment({
      'USB' => node['ii-usb']['target-device']
  }) 
end


directory node['ii-usb']['target-mountpoint']
mount node['ii-usb']['target-mountpoint'] do
  device "#{node['ii-usb']['target-device']}1"
end
