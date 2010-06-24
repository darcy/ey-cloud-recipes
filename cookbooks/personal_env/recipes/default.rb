# Cookbook Name:: mongodb
# Recipe:: default
if ['solo', 'app', 'app_master', 'util'].include?(node[:instance_role])

  execute "add-aliases-to-path" do
    command %Q{
      echo 'alias l="ls -l"' >> /etc/profile &&
      echo 'alias la="ls -la"' >> /etc/profile &&
      echo 'alias ..="cd .."' >> /etc/profile &&
      echo 'alias ...="cd ../.."' >> /etc/profile &&
      echo 'alias ....="cd ../../.."' >> /etc/profile
    }
    not_if "grep 'alias l=\"ls -l\"' /etc/profile"
  end
  
end
