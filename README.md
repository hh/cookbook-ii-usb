Description
===========

This cookboks aims to create bootable USB sticks that contain OS
vendor ISO.  These ISO's are booted for fully automated installs via
seedfiles (Debian/Ubuntu) and Autounattended.xml
(Windows). Chef-client is installed at all possible injection points,
allowing for chef-driven hardware installs.

Currenty Ubuntu 12.04.1 is supported, but Windows and OSX are foreseeable targets.

Requirements
============

* Ubuntu 12.04 host
* Fast USB stick you don't mind formatting.

Attributes
==========

```
node['ii-usb']['target-device']
```
This should be set to '/dev/sdX' which is the block device of your USB.
Some checking is done to try not and fry anything that isn't a usb stick,
however you should note that this may accidentally format your entire drive.

```
node['ii-usb']['src-chef-repo']
```
the path of the chef-repo you want rsynced onto the usb.
Eventually this will be a git resource.

```
node['ii-usb']['target-solo-config'] = 'target-solo.rb'
```
chef-solo config file for chef run on target

Usage
=====

Currently ii-usb::create-usb-solo is the main recipe.

I often use a create-usb-chef-solo.rb that looks like this:

```ruby
current_dir = ::File.dirname(::File.absolute_path(__FILE__))
cookbook_path "#{current_dir}/cookbooks" #, "#{current_dir}/site-cookbooks"

solo_json_file = "#{current_dir}/.chef/create-usb-solo.json"
open(solo_json_file,'w+') do |f|
  f.write(
    {
      "run_list" => [
        "recipe[ii-usb::create-usb-solo]"
        ],
      'ii-usb' => {
        'src-chef-repo' => current_dir, # for now we'll just copy ourselves
        'target-device' => ENV['TARGETUSB'] # We do this to force setting it at runtime
      }
    }.to_json
    )
end
json_attribs solo_json_file

cache_type               'BasicFile'
cache_options( :path => "#{current_dir}/.chef/checksums")
file_cache_path "#{current_dir}/../cache"
file_backup_path "#{current_dir}/.chef/backup"
role_path "#{current_dir}/roles"
verbose_logging false
```

Then run:

```shell
sudo TARGETUSB=/dev/sdc chef-solo -c ./create-usb-solo.rb
sudo umount /media/ii-usb*/ # ubuntu likes to automount....
sudo umount /tmp/ii-usb-target/ # the default mountpoint, so I can put it into my test computer
```