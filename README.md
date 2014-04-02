PlexMediaServerUpdater
======================
Since the Ubuntu repos are down for plexmediaserver I decided to create a quick script to ease the upgrade process for the public release.


What it Does
============
Using Lynx, apt-get, wget, grep, and awk this bash script will check the webpage at http://www.plex.tv/downloads for the lastest public releases for Ubuntu.

By searching for links containing the keyword "deb", excluding the link for the Netgear Intel NAS that for the past two releases has had the word "binaries" in the url. It will then determine the OS type and install the appropriate 64-Bit or 32-Bit deb using dpkg.

How to use this
===============
From the cli (in terminal for gui peeps) type the following to download then run this script:
...

wget https://raw.githubusercontent.com/insanepoet/PlexMediaServerUpdater/master/PMSUpdate.sh

sudo chmod +x PMSUpdate.sh

sudo ./PMSUpdate.sh
...


You could clone the repo, set the script to execute, and run it however if you understand that why are you even reading this :)

What the Future Holds
=====================
If enough people would like I can probably modify this script to encompass other distros etc...



