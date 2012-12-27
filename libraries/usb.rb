class Chef
  class Recipe
    def ii_usb_properties
      usb_devices = Dir['/dev/disk/by-id/usb-*'].reject {|b| b =~ /.*part.*/ }
      usb_raw_properties=usb_devices.map{|n| %x{udevadm info -q property -n #{n}}}
      ii_usb_properties=usb_raw_properties.map do |raw_lines|
        raw_lines.lines.map{|l|l.chomp}.map do |l|
          (k,v)=l.split('=')
          {k=>v}
        end.reduce &:merge
      end
    end
    def ii_current_usb_drives
      ii_usb_properties.map{|x|x['DEVNAME']}.sort
    end
    def ii_current_usb_drives_text
      ii_usb_properties.map do |usb|
        desc = case usb['ID_VENDOR']
               when nil
                 lsusb_regex = /(?<=#{usb['ID_VENDOR_ID']}:#{usb['ID_MODEL_ID']} )(?<description>.*)/
                 m = lsusb_regex.match %x{lsusb -d #{usb['ID_VENDOR_ID']}:#{usb['ID_MODEL_ID']}}
                 m['description']
               else
                 "#{usb['ID_VENDOR']} #{usb['ID_MODEL']}"
               end
        "#{usb['DEVNAME']}: #{desc} #{usb['ID_SERIAL_SHORT']}"
      end.join(', ')
    end
  end
end


