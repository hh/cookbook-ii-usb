default['ii-usb']['ubuntu-iso']['src'] = {
  'url' => 'http://releases.ubuntu.com/precise/ubuntu-12.04.1-desktop-amd64.iso',
  'checksum' => 'd942fd8a056f635062899b58e9e875eb89eaec9be09a0fefa713f4e162bb647e',
  'cache' => File.join(Chef::Config[:file_cache_path],'ubuntu-12.04.1-desktop-amd64.iso')
}

default['ii-usb']['chef-deb']['src'] = {
  'url' => 'https://opscode-omnitruck-release.s3.amazonaws.com/ubuntu/11.04/x86_64/chef_10.16.2-1.ubuntu.11.04_amd64.deb',
  'checksum' => '52a9c858cf11d6d815e419906d7a7debf3460973d3967f9c0ff7a4f9fbac5afd',
  'cache' => File.join(Chef::Config[:file_cache_path],'chef_10.16.2-1.ubuntu.11.04_amd64.deb')
}

default['ii-usb']['target-device']='/dev/null'
default['ii-usb']['target-mountpoint']='/tmp/ii-usb-target'
default['ii-usb']['ubuntu-mountpoint']='/tmp/ii-ubuntu-src'
default['ii-usb']['volume-name']='ii-usb'
  
