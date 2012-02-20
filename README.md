Description
===========

The Syslog NG cookbook installs and configures syslog-ng service.
The cookbook has been written for and tested on CentOS with syslog-ng 2.1.4.
Syslog NG can be obtained [here: balabit.com](http://www.balabit.com/downloads/files?path=/syslog-ng/sources/2.1.4). 

Requirements
============

* Chef 0.8+
* Syslog-NG 2.x package

Usage
=====

### In a run list:
    "run_list": [
        "recipe[syslog-ng]"
    ]

### In a cookbook:
    include_recipe "syslog-ng"
    
    syslog_ng_app application[:name] do
      index "02"
      host "127.0.0.1"
      port "514"
      log_base "/var/applogs"
    end


License and Author
==================

Author:: Artem Veremey (<artem@veremey.net>)

Copyright 2012, Artem Veremey

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Changes
=======

### v 1.0.0

* Initial public release
