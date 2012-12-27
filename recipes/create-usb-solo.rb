if ii_current_usb_drives.include? node['ii-usb']['target-device']
  include_recipe 'ii-usb::_sources'
  include_recipe 'ii-usb::_format_and_mount_usb'
  include_recipe 'ii-usb::_mount_and_copy_ubuntu'
  include_recipe 'ii-usb::_create_usb_cache'
  include_recipe 'ii-usb::_configure_grub'
  include_recipe 'ii-usb::_copy_chef_repo' # this is a hack, refactor me
else
  log "drives must be one of:"
  log ii_current_usb_drives_text
  log "try 'TARGETUSB=/dev/sdX chef-client -c create-usb-solo.rb'"
  ruby_block 'TARGETUSB error' do
    block do
      raise 'You Must set TARGETUSB'
    end
  end
end

