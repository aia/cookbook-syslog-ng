#
# Cookbook Name:: syslog-ng
# Definition:: generate_syslog_ng_conf_if_missing
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

define :generate_syslog_ng_conf_if_missing, :template => "syslog-ng.conf.erb" do
  include_recipe "syslog-ng"

  current_time = Time.now.utc
  syslog_ng_version = node[:syslog_ng][:syslog_ng_version]
  filepath = "#{node[:syslog_ng][:config_dir]}/#{node[:cloudhouse_syslog][:syslog_ng_config_name]}"

  template filepath do
    action :create_if_missing
    source params[:template]
    owner node[:syslog_ng][:user]
    group node[:syslog_ng][:group]
    mode 00640

    variables(
      :current_time => current_time,
      :syslog_ng_version => syslog_ng_version
    )

    notifies :restart, resources(:service => "syslog-ng"), :immediately
  end
  
end
