#
# Cookbook Name:: syslog-ng
# Recipe:: default
#
# Copyright 2011,2012 Artem Veremey
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package "syslog-ng"

ruby_block 'Ensure the syslog-ng main configuration file includes configuration files in conf.d subdirectory' do
  filepath = "#{node[:syslog_ng][:config_dir]}/#{node[:syslog_ng][:syslog_ng_config_name]}"

  block do
    newline = $/

    conf_file = File.open(filepath, 'rb')
    content = conf_file.read
    conf_file.close

    #@include 'conf.d'
    findIncludeExpr = Regexp.new(%q{^\s*@include\s*(?:"|')[a-zA-Z\\/.-]*(?:\\/)?conf.d}, Regexp::MULTILINE)
    match = findIncludeExpr.match(content)

    if match.nil?
      content << %q(@include 'conf.d') + newline

      Tempfile.open(".#{File.basename(filepath)}", File.dirname(filepath)) do |tempfile|
        tempfile.binmode
        tempfile.write(content)
        tempfile.close
        stat = File.stat(filepath)
        FileUtils.chown stat.uid, stat.gid, tempfile.path
        FileUtils.chmod stat.mode, tempfile.path
        FileUtils.mv tempfile.path, filepath
      end
    else
      puts 'Include already present in syslog-ng configuration file.'
    end
  end
  only_if { File.exists? filepath }
end

cookbook_file "/etc/init.d/syslog-ng" do
  owner node[:syslog_ng][:user]
  group node[:syslog_ng][:group]
  mode 00755
  action :create_if_missing
end

directory "#{node[:syslog_ng][:config_dir]}/conf.d" do
  owner node[:syslog_ng][:user]
  group node[:syslog_ng][:group]
  mode 00750
  action :create
end

directory "#{node[:syslog_ng][:log_dir]}" do
  owner node[:syslog_ng][:user]
  group node[:syslog_ng][:group]
  mode 00755
  action :create
end

service "syslog-ng" do
  supports :restart => true, :status => true
  action [ :enable ]
end

generate_syslog_ng_conf_if_missing do
end

template "#{node[:syslog_ng][:config_dir]}/conf.d/00base" do
  source "00base.erb"
  owner node[:syslog_ng][:user]
  group node[:syslog_ng][:group]
  mode 00640
  variables(
    :flush_lines => node[:syslog_ng][:flush_lines],
    :time_reopen => node[:syslog_ng][:time_reopen],
    :log_fifo_size => node[:syslog_ng][:log_fifo_size],
    :chain_hostnames => node[:syslog_ng][:chain_hostnames],
    :use_dns => node[:syslog_ng][:use_dns],
    :create_dirs => node[:syslog_ng][:create_dirs],
    :use_fqdn => node[:syslog_ng][:use_fqdn],
    :keep_hostname => node[:syslog_ng][:keep_hostname],
    :chain_hostnames => node[:syslog_ng][:chain_hostnames],
    :global_opts => node[:syslog_ng][:global_opts]
  )
  notifies :restart, "service[syslog-ng]"
end

service "syslog-ng_start" do
  service_name 'syslog-ng'
  action [ :start ]
end
