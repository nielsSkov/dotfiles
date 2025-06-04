# Multi Monitor Setup

* Symlink the following files and folders (example from ```dotfiles/work/```),  
    ```sh
    sudo ln -s /home/$USER/dotfiles/work/display_setup/99-monitor-hotplug.rules /etc/udev/rules.d/99-monitor-hotplug.rules
    sudo ln -s /home/$USER/dotfiles/work/display_setup/autorandr-systemd-user.sh /usr/local/bin/autorandr-systemd-user.sh
    ln -s /home/$USER/dotfiles/work/display_setup/autorandr /home/$USER/.config/autorandr
    ln -s /home/$USER/dotfiles/work/bspwm /home/$USER/.config/bspwm
    ```

* Profiles in autorandr are unique to the setup - to generate new profiles run,  
    ```sh
    arandr  
    ```
* Set up the screens as desired, apply the layout, close arandr, then run,  
    ```sh
    autorandr --save <profile-name>
    ```

* Make sure relevant files are executable,  
    ```sh
	sudo chmod +x ~/dotfiles/work/display_setup/autorandr-systemd-user.sh
	sudo chmod +x ~/dotfiles/work/bspwm/autorandr-wrapper
	sudo chmod +x ~/dotfiles/work/bspwm/bspwmrc
	sudo chmod +x ~/dotfiles/work/bspwm/layout
    ```

* Edit ```/home/$USER/.config/bspwm/layout``` to match profiles and desired desktop setup

* Restart udev rules and make sure autorandr service works,
    ```sh
    sudo udevadm control --reload
    systemctl --user daemon-reexec
    systemctl --user restart autorandr-scan.service
    ```

* **Optional:** Trigger udev test, no output means success,  
    ```sh
    sudo udevadm trigger -s drm
    ```
