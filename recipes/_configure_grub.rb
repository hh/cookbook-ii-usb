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

# The seedfile should be templated out more
template "#{usb}/preseed.seed" do
  source 'preseed.seed.erb'
end

# The four places we can run custom commands
['initramfs_command','early_command','success_command','firstboot'].each do |script|
  template "#{usb}/#{script}.sh" do
    source "#{script}.sh.erb"
  end
end

['initramfs','early','success'].each do |stage|
  template "#{usb}/ubiquity-#{stage}-solo.rb" do
    source "ubiquity-solo.rb.erb"
    variables({
        stage: stage
      })
  end
end
