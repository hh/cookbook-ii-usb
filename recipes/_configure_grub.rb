usb=node['ii-usb']['target-mountpoint']

template "#{usb}/boot/grub/grub.cfg" do
  source 'grub.cfg.erb'
  variables({
      iso_name: ::File.basename(node['ii-usb']['ubuntu-iso']['src']['cache'])
    })
end

template "#{usb}/boot/grub/x86_64-efi/grub.cfg" do
  source 'efi-grub.cfg.erb'
end

template "#{usb}/preseed.seed" do
  source 'preseed.seed.erb'
end

# The three places we can run custom commands

template "#{usb}/initramfs_command.sh" do
  source 'initramfs_command.sh.erb'
end

template "#{usb}/prepartitioning_command.sh" do
  source 'prepartitioning_command.sh.erb'
end

template "#{usb}/success_command.sh" do
  source 'success_command.sh.erb'
end

