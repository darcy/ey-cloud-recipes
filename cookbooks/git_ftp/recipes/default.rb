# Cookbook Name:: mongodb
# Recipe:: default
if ['solo', 'app', 'app_master', 'util'].include?(node[:instance_role])

  package="resmo-git-ftp-0.0.9-0-g23921a3"
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
      mv #{package} #{dir} &&
      rm #{package}.tgz
    }
    not_if { File.exists?("#{dir}/git-ftp") }
  end
  
  execute "add-to-path" do
    command %Q{
      ln -nfs /usr/local/bin/git-ftp #{dir}/git-ftp
    }
    not_if { File.exists?("#{dir}/git-ftp") }
  end
  
end
