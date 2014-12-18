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

cookbook_file "#{node[:syslog_ng][:config_dir]}/syslog-ng.conf" do
  owner node[:syslog_ng][:user]
  group node[:syslog_ng][:group]
  mode 00640
end

cookbook_file "/etc/init.d/syslog-ng" do
  owner node[:syslog_ng][:user]
  group node[:syslog_ng][:group]
  mode 00755
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
  action [ :enable, :start ]
end

template "#{node[:syslog_ng][:config_dir]}/conf.d/00base" do
  source "00base.erb"
  owner node[:syslog_ng][:user]
  group node[:syslog_ng][:group]
  mode 00640
  variables(
    :sync => node[:syslog_ng][:sync],
    :time_reopen => node[:syslog_ng][:time_reopen],
    :log_fifo_size => node[:syslog_ng][:log_fifo_size],
    :long_hostnames => node[:syslog_ng][:long_hostnames],
    :use_dns => node[:syslog_ng][:use_dns],
    :use_fqdn => node[:syslog_ng][:use_fqdn],
    :create_dirs => node[:syslog_ng][:create_dirs],
    :keep_hostname => node[:syslog_ng][:keep_hostname],
    :chain_hostnames => node[:syslog_ng][:chain_hostnames],
    :global_opts => node[:syslog_ng][:global_opts]
  )
  notifies :restart, "service[:syslog-ng]"
end
