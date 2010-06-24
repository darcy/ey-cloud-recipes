# Cookbook Name:: mongodb
# Recipe:: default
if ['solo', 'app', 'app_master', 'util'].include?(node[:instance_role])

  package="resmo-git-ftp-0.0.9-0-g23921a3"
  package_folder="resmo-git-ftp-23921a3"
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
      
      curl -L http://github.com/resmo/git-ftp/tarball/0.0.9 -o #{package}.tgz &&
      tar zxvf #{package}.tgz &&
      mv #{package_folder}/* #{dir}/. &&
      rm #{package}.tgz &&
      rm #{package_folder}
    }
    not_if { File.exists?("#{dir}/git-ftp") }
  end
  
  execute "add-to-path" do
    command %Q{
      mkdir -p #{dir}/bin &&
      ln -nfs #{dir}/git-ftp #{dir}/bin/git-ftp &&
      echo 'export PATH="$PATH:#{dir}/bin"' >> /etc/profile
    }
    not_if "grep 'export PATH=$PATH:#{dir}/bin' /etc/profile"
  end
  
end
