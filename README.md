# vagrd
Automatic creation of Ramdisk for Vagrant/Meteor development. Fast autoreload and rebuilding app for your Meteor project

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
- Create RAM-storage: http://www.observium.org/wiki/Persistent_RAM_disk_RRD_storage
- Move meteor to RAM storage: http://www.solidmeteor.com/fasten-your-seatbelt-were-going-to-speed-up-a-meteor-gear-1-the-linux-speedway/
- Also you need quickmeteor for speed up meteor work on RAM disk: https://github.com/eluck/quickmeteor


Информация:

Разработчик: Виталий Петров aka kafeg, v31337[at]gmail.com

http://forsk.ru - адекватная автоматизация бизнес процессов.

http://skid.kz - автоматический агрегатор скидок Республики Казахстан.

http://kellot.ru - онлайн табель учёта рабочего времени по формам Т-12 и Т-13.
