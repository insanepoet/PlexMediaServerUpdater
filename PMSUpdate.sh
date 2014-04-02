#!/bin/bash
# ------------------------------------------------------------------------- #
#            __  ___       ___      ____             ___                    #
#           /  |/  /__ ___/ (_)__ _/ __/__ _____  __/ _ \_______            #
#          / /|_/ / -_) _  / / _ `/\ \/ -_) __/ |/ / ___/ __/ _ \           #
#         /_/  /_/\__/\_,_/_/\_,_/___/\__/_/  |___/_/  /_/  \___/           #
#                                                                           #
# ------------------------------------------------------------------------- #
# ------------------------------------------------------------------------- #
# --   Automatic Updater Script for Plex Media Server Public Release     -- # 
# --   This will have to do until the ubuntu repos return, scrapes the   -- #
# --   http://www.plex.tv/downloads page for .deb files then uses the    -- #
# --   keyword binaries to exclude netgear intel deb file.               -- #
# --                   !!! Must be run with sudo !!!                     -- #
# ------------------------------------------------------------------------- #
# -- Author: Rory G. Fincham ("Insanepoet") © 2014                       -- #
# ------------------------------------------------------------------------- #
# ------------------------------------------------------------------------- #
# --    This program is free software: you can redistribute it and/or    -- #
# --    modify it under the terms of the GNU General Public License as   -- # 
# -- published by the Free Software Foundation, either version 3 of the  -- #
# --                License, or any later version.                       -- #
#                                                                           #
# --   This program is distributed in the hope that it will be useful,   -- #
# --   but WITHOUT ANY WARRANTY; without even the implied warranty of    -- #
# --   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the     -- #
# --             GNU General Public License for more details.            -- #
#                                                                           #
# --       To Review a copy of the GNU General Public License see:       -- #
# --                 <http://www.gnu.org/licenses/>                      -- #
# ------------------------------------------------------------------------- #
# ------------------------------------------------------------------------- #
# --                            Do You Sudo?                             -- #
# ------------------------------------------------------------------------- #
# -- Make sure script is being run with privileges
if [[ $UID != 0 ]]; then
    echo "This script uses apt and dpkg and must be run in sudo!"
    echo "Use 'sudo $0 $*' then enter your password when prompted."
    exit 1
fi
# ------------------------------------------------------------------------- #
# --               Get Required packages for script to run               -- #
# ------------------------------------------------------------------------- #
# -- Combined from a few scripts from the MSP installer for sharing with the plex forums.
# -- Checks status and installs from default dependancies if needed.
pkgs=(

lynx
dpkg
avahi-daemon
avahi-utils

)
for pkg in "${pkgs[@]}"
do
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $pkg |grep "install ok installed")
echo ":: Checking for $pkg"
if [ "$PKG_OK" == "" ]; then
  echo ":: Missing $pkg! Let's get that fixed!."
	apt-get --force-yes --yes install $pkg
fi
done
echo ":: Everything needed is installed and ready!"
echo ":: Moving on..."
# ------------------------------------------------------------------------- #
# --                        Get URL's from Plex.TV                       -- #
# ------------------------------------------------------------------------- #
# -- Let's Get the most recent public release download URL's 
echo ":: Grabbing links to .deb packages from http://www.plex.tv/downloads"
debs=$(lynx -dump http://www.plex.tv/downloads  | grep 'http://' | awk '/deb/{print $2}')
echo ":: Searching for .deb packages"
for i in $debs
do
if [[ $i != *binaries* ]] # Excludes Netgear NAS deb file - This may change in the future!?!
then
   if [[ $i == *amd64* ]] # 64 bit download
   then
   sixforbit="$i"
   elif [[ $i == *i386* ]] # 32 bit download 
   then
   thirtoobit="$i"
   fi
   echo $i
fi
echo $i
done
# ------------------------------------------------------------------------- #
# --      Spit out the urls (Mostly for testing but why take it out?)    -- #
# ------------------------------------------------------------------------- #
echo ":: Here is what i found:"
echo ":: 64-Bit Download"
echo $sixforbit
echo ""
echo ":: 32-Bit Download"
echo $thirtoobit
echo ""
# ------------------------------------------------------------------------- #
# --                 wget and install based on os type                   -- #
# ------------------------------------------------------------------------- #
if [ `uname -m | grep "x86_64"` ]; 
then
	echo ":: 64-Bit OS Detected - Installing / Upgrading PMS"
	sleep 2
	DlUrl=$sixforbit  
else
	echo ":: Ugh.. 32-Bit OS Detected - Installing / Upgrading PMS against my better judgement" # Because i have to bust their balls just one more time
	sleep 2
	DlUrl=$thirtoobit 
fi
FILE=`mktemp` # Let's use a temp file
wget $DlUrl -qO $FILE && dpkg -i $FILE # Get it & Install
rm $FILE # Get rid of our temp file
echo ":: All Done latest Public Release from http:/www.plex.tv/downloads installed!"
echo ":: Have a nice day!"
exit 0