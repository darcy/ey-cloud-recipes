# Cookbook Name:: mongodb
# Recipe:: default
if ['solo', 'app', 'app_master', 'util'].include?(node[:instance_role])

  package_location="http://github.com/darcy/git-ftp/raw/master/git-ftp"
  
  dir = "/usr/local/git-ftp"
  
  directory dir do
    owner node[:owner_name]
    group node[:owner_name]
    mode 0755
    recursive true
    not_if { File.directory?(dir) }
  end

  execute "install-git-ftp" do
    command %Q{
      curl -L #{package_location} -o #{dir}/git-ftp &&
      chmod 755 #{dir}/git-ftp
    }
    not_if { File.exists?("#{dir}/git-ftp") }
  end
  
  execute "add-to-path" do
    command %Q{
      echo 'export PATH="$PATH:#{dir}"' >> /etc/profile
    }
    not_if "grep 'export PATH=\"$PATH:#{dir}\"' /etc/profile"
  end
  
end
