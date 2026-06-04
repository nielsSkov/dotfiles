# profiles reside in /etc/netctl/

# The .pem certificate can be retrieved by running the aau-script
# (first make sure that network-manager is not installed)
# The script will fail, but ask if you want to save the configurations (say yes)
# Then an example profile will be provided along with a .pem-file
# Do not place the .pem-file in the seemingly appropriate folder, as this
# will be cleaned on every system upgrade.
# Do however make sure that the path in the profile cooresponds to the location
# of the .pem-file

# The profiles provided here are tested, and works with netctl-auto.
    sudo pacman -S wpa_actiond
    sudo systemctl enable netctl-auto@interface.service
(replace interface in the above command with the actual interface, i.e. wlp2s0)

# To make sure that it works after suspend to ram,
# install and enable the AUR "netctl-auto-resume"
    sudo pacaur -S netctl-auto-resume
    sudo systemctl enable netctl-auto-resume@interface.service
(again replace interface with i.e. wlp2s0)

# To generate hashed passwords see the encryptPassword.txt
# Anyone can still use the password to connect, but they cannot read it
# and thus your other asociated accounts accessed with this password
# will still be protected in this manner.
# The hashed passwords in the profiles are "destroyed" and only included
# as an example, so new ones must be gennerated.
# The two normal profiles are generated with "wifi-menu -o" which
# which automaticly hides the passwords when the "-o" option is set.
# When the passwords are generated manually, this is the syntax
    'password=hash:bfd0e5c73e1a4ef216ef260e5ebb1fd'

# If you want to use plain text passwords, this is the syntax
    'password="yogurt1234"'

# Set permissions for the profiles to -rw-------
    sudo chmod 600 profile
# (replace profile with i.e. wlp2s0-Skov)

# There may be steps missing in this instruction as it is written
# some time after the install. So always read the arch wiki.

Good luck!
