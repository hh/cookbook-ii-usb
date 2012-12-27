# from Adam - https://gist.github.com/1185022 - https://gist.github.com/4384614
require 'fileutils'
class Chef
  class Provider
    class File
      class Copy < Chef::Provider::File
        def content_differs
          checksum(@current_resource.path) != checksum(@new_resource.content)
        end
        
        def set_content
          if content_differs
            backup @new_resource.path if ::File.exists?(@new_resource.path)
            ::FileUtils.cp(@new_resource.content, @new_resource.path)
            Chef::Log.info("#{@new_resource.content} copied to #{@new_resource.path}")
            @new_resource.updated_by_last_action(true)
          end
        end
      end
    end
  end
end
