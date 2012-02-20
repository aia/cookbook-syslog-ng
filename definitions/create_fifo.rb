#
# Cookbook Name:: syslog-ng
# Definition:: create_fifo
#
# Copyright 2012, Artem Veremey
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

define :create_fifo do
  filename = params[:name]
  filemode = params[:mode] || "00644"
  fileowner = params[:owner] || "root"
  filegroup = params[:group] || "root"
  
  execute "creating_fifo" do
    command "mkfifo #{filename}"
    creates filename
    action :run
  end
  
  file filename do
    owner fileowner
    group filegroup
    mode filemode
  end
end