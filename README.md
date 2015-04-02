# vagrd
Ramdisk for Vagrant/Meteor development. Fast autoreload and rebuilding app for your Meteor project

Simple using daemon for create ramdisk for your Meteor projects in vagrant virtual machine.

install and usage (ONLY FOR UBUNTU 14.04, not tested for other operating systems!!!):
1) Download vagrd.sh
2) Run 'chmod a+x ./vagrd.sh'
3) Run 'sudo ./vagrd.sh install'
4) Move your project to folder /vagrant/ramproj
5) Run 'sudo service vagrd start'
5) Edit your code in directory /vagrant/ramdisk

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
1) http://www.observium.org/wiki/Persistent_RAM_disk_RRD_storage
2) http://www.solidmeteor.com/fasten-your-seatbelt-were-going-to-speed-up-a-meteor-gear-1-the-linux-speedway/
