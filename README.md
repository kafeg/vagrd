# vagrd
Ramdisk for Vagrant/Meteor development. Fast autoreload and rebuilding app for your Meteor project

Simple using daemon for create ramdisk for your Meteor projects in vagrant virtual machine.

install and usage (ONLY FOR UBUNTU 14.04, not tested for other operating systems!!!):
- Download vagrd.sh
- Run 'chmod a+x ./vagrd.sh'
- Run 'sudo ./vagrd.sh install'
- Move your project to folder /vagrant/ramproj
- Run 'sudo service vagrd start'
- Edit your code in directory /vagrant/ramdisk

Ramdisk include 3 folders:
- ~/.meteor
- ~/.npm
- /vagrant/ramdisk

Crontab include:
2 * * * * root        service vagrd sync >> /dev/null 2>&1

Log file at /var/log/vagrd_sync.log

For uninstall run 'sudo service vagrd uninstall'

Meteor Vagrant installation: https://github.com/shoebappa/vagrant-meteor-windows

More details:
- http://www.observium.org/wiki/Persistent_RAM_disk_RRD_storage
- http://www.solidmeteor.com/fasten-your-seatbelt-were-going-to-speed-up-a-meteor-gear-1-the-linux-speedway/
