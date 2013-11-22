execute "Install and open Checkman Mac app into /Applications" do
  command "\curl https://raw.github.com/#{node['sprout']['checkman']['github_user']}/checkman/master/bin/install | bash -s"
  user node['current_user']
  only_if { `ls /Applications/Checkman.app`.empty? }
end

node['sprout']['checkman']['files'].each do |filename, entries|
  config_data = ""
  entries.each do |checkman_entry|
    config_data += "#{checkman_entry.name}: #{checkman_entry.configuration}\n"
  end

  execute "Creates/Updates Checkman configuration" do
    command "echo '#{config_data}' > #{node['sprout']['home']}/Checkman/#{filename}"
    user node['current_user']
    not_if { config_data.empty? }
  end
end
