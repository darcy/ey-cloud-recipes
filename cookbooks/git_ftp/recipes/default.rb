# Cookbook Name:: mongodb
# Recipe:: default
if ['solo', 'app', 'app_master', 'util'].include?(node[:instance_role])

  package="darcy-git-ftp-0.0.8-0-g6abdb4b"
  package_folder="darcy-git-ftp-dc9b4b1"
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
      
      curl -L http://github.com/darcy/git-ftp/tarball/0.0.8 -o #{package}.tgz &&
      tar zxvf #{package}.tgz &&
      mv #{package_folder}/* #{dir}/. &&
      rm #{package}.tgz &&
      rm #{package_folder}
    }
    not_if { File.exists?("#{dir}/git-ftp.sh") }
  end
  
  execute "add-to-path" do
    command %Q{
      mkdir -p #{dir}/bin &&
      chmod 755 #{dir}/bin/git-ftp.sh &&
      ln -nfs #{dir}/git-ftp.sh #{dir}/bin/git-ftp &&
      echo 'export PATH="$PATH:#{dir}/bin"' >> /etc/profile
    }
    not_if "grep 'export PATH=\"$PATH:#{dir}/bin\"' /etc/profile"
  end
  
end
