Description
===========

This cookboks aims to create bootable USB sticks that contain OS vendor ISO.
Currenty Ubuntu 12.04.1 is supported, but Windows and OSX are foreseeable targets.


## Ubuntu allows for booting ISOs with seeded execute at different stages

### https://help.ubuntu.com/community/Grub2/ISOBoot/Examples
* 

### https://wiki.ubuntu.com/UbiquityAutomation
* preseed/early_command #chef before gui
* ubiquity/success_command #chef on target system

### https://help.ubuntu.com/12.04/installation-guide/i386/preseed-advanced.html#preseed-hooks
* partman/early_command #chef before partitioning

This allows us to have a chef-client/solo run during OS installation,
even before partitioning has taken place.

Requirements
============

* Fast USB stick you don't mind formatting.
* Ubuntu 12.04 host

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
sudo TARGETUSB=/dev/sdc /opt/opscode/bin/chef-solo -c ./create-usb-solo.rb
sudo umount /media/ii-usb*/ # ubuntu likes to automount....
sudo umount /tmp/ii-usb-target/ # the default mountpoint, so I can put it into my test computer
```