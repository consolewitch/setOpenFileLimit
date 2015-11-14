#!/bin/bash
echo ==========================================================================
echo  This will set the default max open files for all users on your Mac 
echo ==========================================================================
echo
DEFAULTHARDMAXOPENFILES=524288
DEFAULTSOFTMAXOPENFILES=4096
read -p "To what value should I set your HARD open files limit? [524288]: " HARDMAXOPENFILES 
read -p "To what value should I set your SOFT open files limit? [4096]: " SOFTMAXOPENFILES
echo
HARDMAXOPENFILES=${HARDMAXOPENFILES:-$DEFAULTHARDMAXOPENFILES}
SOFTMAXOPENFILES=${SOFTMAXOPENFILES:-$DEFAULTSOFTMAXOPENFILES}
cat <<EOM >/tmp/limit.maxfiles.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
        "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>limit.maxfiles</string>
    <key>ProgramArguments</key>
    <array>
      <string>launchctl</string>
      <string>limit</string>
      <string>maxfiles</string>
      <string>$SOFTMAXOPENFILES</string>
      <string>$HARDMAXOPENFILES</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>ServiceIPC</key>
    <false/>
  </dict>
</plist>
EOM
OSVER=`sw_vers -productVersion |cut -d . -f 2`
if [ $OSVER == '10' -o $OSVER == '11' ]
then
  if [ -f /Library/LaunchDaemons/limit.maxfiles.plist ]
  then
    echo Error: /Library/launchctlhDaemons/limit.maxfiles.plist exists. Edit it to set your max open files.
    echo
  else
    sudo mv /tmp/limit.maxfiles.plist /Library/LaunchDaemons/
    echo You must reboot before the setting will take effect.
    sudo chown root /Library/LaunchDaemons/limit.maxfiles.plist
  fi
else
  echo Error: Untested OS X version.
fi