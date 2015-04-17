#! /bin/bash -x
# /etc/init.d/ramdisk.sh
#

# for testing
#  sudo ./vagrd.sh uninstall && sudo ./vagrd.sh install && sudo ./vagrd.sh start && ls /vagrant/ && ls /vagrant/ramdisk/ && echo '321' >> /vagrant/ramdisk/test.txt && sudo ./vagrd.sh sync && ls /vagrant/ramproj/ && cat /vagrant/ramproj/test.txt

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

USERNAME="notfound"

case "$1" in
  start)
    echo "Copying project files to ramdisk"
    rsync -av /vagrant/ramproj/ /vagrant/ramdisk/
    echo "Copying .meteor and .npm files to ramdisk"
    rsync -avv --delete /home/$USERNAME/.meteor_persistent/ /home/$USERNAME/.meteor/
    rsync -avv --delete /home/$USERNAME/.npm_persistent/ /home/$USERNAME/.npm/
    echo "Chmod for .meteor and .npm"
    chown $USERNAME -R /home/$USERNAME/.meteor /home/$USERNAME/.meteor_persistent /home/$USERNAME/.npm /home/$USERNAME/.npm_persistent
    chmod u=rwx -R /home/$USERNAME/.meteor /home/$USERNAME/.meteor_persistent /home/$USERNAME/.npm /home/$USERNAME/.npm_persistent
    chmod o=r -R /home/$USERNAME/.meteor /home/$USERNAME/.meteor_persistent /home/$USERNAME/.npm /home/$USERNAME/.npm_persistent
    echo "Chmod for project"
    chown $USERNAME -R /vagrant/ramdisk/
    chmod 777 -R /vagrant/ramdisk/
    echo [`date +"%Y-%m-%d %H:%M"`] Ramdisk Synched from HDD >> /var/log/vagrd_sync.log
    ;;
  sync)
    echo "Synching files from ramdisk to Harddisk"
    echo [`date +"%Y-%m-%d %H:%M"`] Ramdisk Synched to HDD >> /var/log/vagrd_sync.log
    rsync -av --delete --recursive --force /vagrant/ramdisk/ /vagrant/ramproj/
    rsync -avv --delete /home/$USERNAME/.meteor/ /home/$USERNAME/.meteor_persistent/
    rsync -avv --delete /home/$USERNAME/.npm/ /home/$USERNAME/.npm_persistent/
    ;;
  stop)
    echo "Synching logfiles from ramdisk to Harddisk"
    echo [`date +"%Y-%m-%d %H:%M"`] Ramdisk Synched to HDD >> /var/log/vagrd_sync.log
    rsync -av --delete --recursive --force /vagrant/ramdisk/ /vagrant/ramproj/
    rsync -avv --delete /home/$USERNAME/.meteor/ /home/$USERNAME/.meteor_persistent/
    rsync -avv --delete /home/$USERNAME/.npm/ /home/$USERNAME/.npm_persistent/
    ;;
  install)
    echo "Install Meteor ramdisk"
    echo [`date +"%Y-%m-%d %H:%M"`] Start install Ramdisk >> /var/log/vagrd_sync.log
    if [ -d "/vagrant" ]; then
      if [ -d "/home/$SUDO_USER/.meteor" ]; then
	if [ -d "/home/$SUDO_USER/.npm" ]; then
	  if [ ! -d "/vagrant/ramdisk" ]; then
	    echo "Backup to /home/$SUDO_USER/vagrant_backup.tar.gz"
	    tar -zcvf /home/$SUDO_USER/vagrant_backup.tar.gz /vagrant
	    tar -zcvf /home/$SUDO_USER/.meteor_files_backup.tar.gz /home/$SUDO_USER/.npm /home/$SUDO_USER/.meteor
    	    echo "Move folders /home/$SUDO_USER/.npm to /home/$SUDO_USER/.npm_persistent and /home/$SUDO_USER/.meteor to ~/.meteor_persistent"
            mv /home/$SUDO_USER/.npm /home/$SUDO_USER/.npm_persistent
            mv /home/$SUDO_USER/.meteor /home/$SUDO_USER/.meteor_persistent

	    echo "Make folders /home/$SUDO_USER/.npm and /home/$SUDO_USER/.meteor"
	    mkdir /home/$SUDO_USER/.npm
	    mkdir /home/$SUDO_USER/.meteor

	    echo "Copy script to /etc/init.d/vagrd"
	    cp ${0} /etc/init.d/vagrd
	    sed -i "s/USERNAME=\"notfound\"/USERNAME=\"$SUDO_USER\"/g" /etc/init.d/vagrd
            chmod a+x /etc/init.d/vagrd

	    echo "Create folder /vagrant/ramdisk"
	    mkdir /vagrant/ramdisk
	    mkdir /vagrant/ramproj
	    echo 'test' > /vagrant/ramproj/test.txt

	    echo "Create tmpfs in fstab"
	    echo "tmpfs /vagrant/ramdisk tmpfs      defaults,noatime,mode=077 0 0" >> /etc/fstab
    	    echo "tmpfs /home/$SUDO_USER/.meteor	tmpfs	defaults,noatime,mode=077 0 0" >> /etc/fstab
	    echo "tmpfs /home/$SUDO_USER/.npm tmpfs      defaults,noatime,mode=077 0 0" >> /etc/fstab

	    echo "Mounting /vagrant/ramdisk, /home/$SUDO_USER/.meteor and /home/$SUDO_USER/.npm"
	    mount /vagrant/ramdisk
	    mount /home/$SUDO_USER/.npm
	    mount /home/$SUDO_USER/.meteor

	    echo "Install service vagrd"
	    update-rc.d vagrd defaults 00 99
	    echo `ls /vagrant/ramdisk`

	    echo "Install cron sync task"
	    echo "*/2 * * * * root        service vagrd sync >> /dev/null 2>&1" >> /etc/crontab
	    echo "Installation complete! Run 'sudo service vagrd start'"
          else
            echo "Script already installed! Exit..."
            echo [`date +"%Y-%m-%d %H:%M"`] Script already installed! >> /var/log/vagrd_sync.log
          fi
        else
          echo "Npm not found! Exit..."
          echo [`date +"%Y-%m-%d %H:%M"`] Npm not found! >> /var/log/vagrd_sync.log
        fi
      else
        echo "Meteor not found! Exit..."
        echo [`date +"%Y-%m-%d %H:%M"`] Meteor not found! >> /var/log/vagrd_sync.log
      fi
    else
      echo "Vagrant dir not found! Exit..."
      echo [`date +"%Y-%m-%d %H:%M"`] Vagrant not found! >> /var/log/vagrd_sync.log
    fi
    ;;
  uninstall)
    if [ -d "/vagrant/ramdisk" ]; then
      echo "Unnstall Meteor ramdisk"
      echo [`date +"%Y-%m-%d %H:%M"`] Start uninstall Ramdisk >> /var/log/vagrd_sync.log
      echo "Stop service"
      service vagrd stop

      echo "Unount tmpfs"
      umount /vagrant/ramdisk
      umount /home/$SUDO_USER/.npm
      umount /home/$SUDO_USER/.meteor

      echo "Remove dirs"
      rmdir /vagrant/ramdisk
      rmdir /home/$SUDO_USER/.npm
      rmdir /home/$SUDO_USER/.meteor

      echo "Restore old dirs"
      mv /home/$SUDO_USER/.npm_persistent /home/$SUDO_USER/.npm
      mv /home/$SUDO_USER/.meteor_persistent /home/$SUDO_USER/.meteor
      rm /vagrant/ramproj/test.txt
      rmdir /vagrant/ramproj

      echo "Restore fstab"
      sed -i '\/vagrant\/ramdisk/d' /etc/fstab
      sed -i "\/home\/$SUDO_USER\/.meteor/d" /etc/fstab
      sed -i "\/home\/$SUDO_USER\/.npm/d" /etc/fstab

      echo "Restore crontab"
      sed -i '/vagrd/d' /etc/crontab

      echo "Remove service"
      update-rc.d -f vagrd remove
      rm /etc/init.d/vagrd
    else
      echo "Ramdisk not found! Exit..."
      echo [`date +"%Y-%m-%d %H:%M"`] Ramdisk not found! >> /var/log/vagrd_sync.log
    fi
    ;;
  *)
    echo "Usage: /etc/init.d/vagrd {start|stop|sync|install|uninstall}"
    exit 1
    ;;
esac

exit 0
