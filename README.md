auto-cygwin-install
===================

Automated cygwin install. 

Download the project as a zip file and extract to expose the files. There are two batch scripts depending on your need.

  1. cygwin + apt-cyg use:  cygwing-install-with-apt-cyg.bat with apt-cyg being a package manager similar to apt-get in Debian Linux
  2. cygwin - a simple installer without all the extras use: cygwin-install.bat

Modify the PACKAGES varialbe to add or remove binaries/sources to suite. Note there are minimum base requirements for apt-cyg, so be cautious when 'removing' items.

Downloaded zip archives destroy the formatting (at least it did for me) of the batch files. I found simply copying and pasting from the file view on github solved the problem.

The current setup files as of this writing for Vista or greater OS is 2.6.0 for 32 and 64 bit versions. Check for updates after 03NOV16 if you encounter issues with the actual cygwin install.


Mods based off these authors efforts.

Created by wjrogers: https://gist.github.com/wjrogers/1016065.

Suggest this workflow for this project: http://scottchacon.com/2011/08/31/github-flow.html

apt-cyg rtwolf https://github.com/rtwolf/cygwin-auto-install/
