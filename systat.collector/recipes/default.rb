#
# Cookbook:: systat.collector
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
execute 'Install sysstat' do
  command 'apt-get update && apt-get install sysstat -y'
end

systemd_unit 'sysstat.service' do
 content <<-EOU.gsub(/^\s+/, '')
[Unit]
Description=system activity accounting tool
Documentation=man:sa1(8)

[Service]
Type=oneshot
User=root
ExecStart=/usr/bin/sar 1 3
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=sysstat-collect
 EOU

 action [:create, :enable, :start]
end

systemd_unit 'sysstat.timer' do
 content <<-EOU.gsub(/^\s+/, '')
 [Unit]
 Description=Run system activity accounting tool every 10 minutes

 [Timer]
 OnCalendar=*:00/05

 [Install]
 WantedBy=sysstat.service
 EOU


 action [:create, :enable, :start]
end

systemd_unit 'foo.service' do
 content <<-EOU.gsub(/^\s+/, '')
 [Unit]
 Description=Foo

 [Service]
 ExecStart=/bin/sh -c 'while true; do echo "Running Foo"; sleep 5; done'
 

 [Install]
 WantedBy=multi-user.target
 EOU

 action [:create, :enable, :start]
end
