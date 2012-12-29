# Make sure it's unmounted before we possibly format it
directory node['ii-usb']['ubuntu-mountpoint']

mount node['ii-usb']['ubuntu-mountpoint'] do
  device node['ii-usb']['ubuntu-iso']['src']['cache']
  options 'loop'
  not_if "cat /proc/mounts | grep #{node['ii-usb']['ubuntu-mountpoint']}"
end

directory "#{node['ii-usb']['target-mountpoint']}/efi/boot" do
  recursive true
end

file "#{node['ii-usb']['target-mountpoint']}/efi/boot/bootx64.efi" do
  content "#{node['ii-usb']['ubuntu-mountpoint']}/efi/boot/bootx64.efi"
  backup false
  provider Chef::Provider::File::Copy
end

# execute "grub-install --boot-directory=#{node['ii-usb']['target-mountpoint']}/boot/grub/i386-pc #{node['ii-usb']['target-device']}" do
#   creates "#{node['ii-usb']['target-mountpoint']}/boot/grub/i386-pc/grubenv"
# end

['boot/grub/x86_64-efi','boot/grub','.disk'].each do |dir|
  directory "#{node['ii-usb']['target-mountpoint']}/#{dir}" do
    recursive true
  end
  Dir["#{node['ii-usb']['ubuntu-mountpoint']}/#{dir}/*"].each do |file_to_copy|
    next if file_to_copy =~ /.*grub.cfg$/ # omit grub.cfg
    afile = File.basename(file_to_copy)
    afile_src = File.join(node['ii-usb']['ubuntu-mountpoint'],dir,afile)
    afile_target = File.join(node['ii-usb']['target-mountpoint'],dir,afile)
    if File.file? afile_src
      file afile_target do
        backup false
        content afile_src
        provider Chef::Provider::File::Copy
      end
    end
  end
end

