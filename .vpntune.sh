#!/usr/bin/bash

# code found on backup.modalen.2
# whois drunkenbashcodemonkey?


# default settings
default=1 # 0 to use default vpn conf
defp="vpn/ovpn/ovpn.config/multihop.no.ovpn.com.ovpn" # path to default vpn conf
confperm="640" # file perm
confowner="root:root" # owner and group is default root
credfile="" #set path to file with credz. This can also be set in the vpn conf file
# eol settings
clear
set -m

if [ "$EUID" -ne 0 ]
  then echo "run as root"
  exit
fi
clear
printf "use default(y/n)\n $defp\n>"
read input
if [ "$?" -ne 0 ]
    then
      if ["$input" == "y"]
        then
          default = 0
      elif ["$input" == "n"]
        then
          default = 1
      else
        echo "err input"
        exit
      fi
fi
if [ "$default" == 1 ]
  then
      printf "set path to ovpn config\n> "
      read input
      defp=$input
      tmpP=`stat -c %a $defp`
      tmpO=`stat -c %U:%G $defp`
      if [ $tmpP == $confperm ] && [ $tmpO == $confowner ]
        then
          echo "[+] config file ok $tmpP:$tmpO"
          echo "[!] trying to connect"
          openvpn --auth-nocache --verb 3 --config $defp  2>/dev/null 
      fi
fi

if [ "$default" == 0 ]
  then
      tmpP=`stat -c %a $defp`
      tmpO=`stat -c %U:%G $defp`
      if [ $tmpP == $confperm ] && [ $tmpO == $confowner ]
        then
          echo "[+] config file ok $tmpP:$tmpO"
          echo "[!] trying to connect"
          openvpn --auth-nocache --verb 3 --config $defp 2>/dev/null  
      fi
fi
printf 'enable killswitch? (y/n)\nnote - tun0 is default adapter for openvpn.\n>'
read input
ks=$input
if [ "$kf" == "y" ]
  then
    echo "[!] trying to enable killswitch"
    bash vpn/killswitch/killswitch.sh -e & >/dev/null
fi

#ehco 'path to script: vpn/killswitch/killswitch.sh\n'
menu(){
  clear
  echo 'killswiitch '
  echo 'Basic usage is to simply call the script with a valid option.\n-e\t enable killswitch (turn it on)\n-d\tdisable killswitch (turn it off)'
  echo '-t [CIDR]\topen outgoing (ufw) route to a specific CIDR (ip address or range)\nTurn on (enable) the killswitch and allow outgoing route to to some server, e.g. 93.184.216.34: vpnkillswitch -et 93.184.216.34'
  echo '\n\n'
  echo 'openvpn basics\n'
  echo '--client-disconnect\tdissonnect\n--tmp-dir dir\n--cert file\n --help or man for more options\n'
  echo 'disable killswitch before stop openvpn\n'
  read input
  cmd=$input
  $cmd
}


menu
exit
