directory "#{node['ii-usb']['target-mountpoint']}/cache"

['ubuntu-iso','chef-deb'].each do |cf|
  target_file = File.join(node['ii-usb']['target-mountpoint'],'cache',
    File.basename(node['ii-usb'][cf]['src']['cache']))
  file target_file do
    content node['ii-usb'][cf]['src']['cache']
    provider Chef::Provider::File::Copy
    backup false
    not_if {File.file?(target_file) && File.size(target_file) > 10*100*100 }
  end
end
