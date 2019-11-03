#Any comments with ## are meant for Debian and should be ignored

seperate() {
for I in $(seq 30); do echo -n " "; done
}

list() {
echo -e "
badfile
hosts
top
backdoor
firewall
kernel
startup
rootlogin
passwords
shadow
updates
admins
qqr
sudoers
guest
autologin
policy
viruses
external
scan
"
}


badfile() {
echo -n "[Possible File Threats]"
seperate
locate home | grep -ie password -ie users -ie passlist
echo
##/home is just to filter out the non user directories
#Use the -ie flag to add more search terms
echo
}

hosts() {
echo -n "[Possible Threats in /etc/hosts]"
seperate
grep "www" /etc/hosts
echo
}

backdoor() {
echo -n "[Possible Backdoor Threats]"
seperate
ps x | grep -ie "nc" -ie "netcat" | grep -iv "grep"
echo
}

firewall() {
#Requires ufw
echo -n "[Firewall Status]"
seperate
sudo ufw status
echo
}

kernel() {
echo -n "[Kernel Release]"
seperate
uname -r
echo
echo -n "[Kernel Version]"
seperate
uname -v
echo
}

startup() {
##echo -n "[rc.local Non-comment Results]"
seperate
##cat /etc/rc.local | grep -v "#"
echo
}

rootlogin() {
echo -n "[Root Login]"
seperate
cat /etc/ssh/sshd_config | grep PermitRootLogin
echo
}

passwords() {
echo -n "[Profiles Without Password]"
seperate
sudo grep "::1" /etc/shadow
#Warning: Check Shadow file manually for "::1" or similar
echo
}

shadow() {
echo -n "[Profiles in Shadow]"
seperate
sudo grep -ve root -ve daemon -ve bin -ve sys -ve sync -ve games -ve man -ve lp -ve mail -ve news- -ve uucp -ve proxy -ve data -ve news -ve backup -ve list -ve irc -ve gnats -ve nobody -ve libuuid -ve messagebus -ve usbmux -ve dnsmasq -ve avahi -ve kernoops -ve saned -ve whoopsie -ve speech-dispatcher -ve lightdm -ve colord -ve hplip -ve pulse -ve ftp -ve rtkit /etc/shadow | cut -f1 -d":"
echo
}

updates() {
echo -n "[Update Invterval]"
seperate
##sudo grep -P '(?<=Update-Package-Lists ").' /etc/apt/apt.conf.d/10periodic
echo
echo -n "[Auto Updates]"
seperate
##sudo grep -P '(?<=Unattended-Upgrade ").' /etc/apt/apt.conf.d/10periodic
echo
}

admins() {
echo -n "[Current Admins]"
seperate
sudo getent group sudo
echo
}

sudoers() {
#Do not trust results from this function
echo -n "[Sudoers File Results (!!Not Trusted)!!]"
seperate
sudo cat /etc/sudoers | grep -ve "#" -ve "Defaults" -ve "%sudo" -ve "%admin"
echo
}

guest() {
echo -n "[Guest Account]"
seperate
##sudo cat /usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf
echo
}

autologin() {
echo -n "[Auto Login]"
seperate
##cat /usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf | grep -i auto
echo
}

greeter() {
echo -n "[Greeter]"
seperate
##cat /usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf | grep -i greeter
echo
}

policy() {
echo -n "[Password Retries]"
seperate
sudo cat /etc/login.defs | grep -i LOGIN_RETRIES
echo
echo -n "[Max Password Age]"
seperate
cat /etc/login.defs | grep ^PASS_MAX_DAYS
echo
echo -n "[Minimum Password Age]"
seperate
cat /etc/login.defs | grep ^PASS_MIN_DAYS
echo
}

program() {
echo -n "[Possible Hacking Tools]"
seperate
apt list --installed | grep -ie john -ie samba -ie netcat -ie metasploit -ie nmap -ie openssh -ie wiresharl -ie nessus -ie aircrack -ie snort -ie crack
echo
}

viruses() {
if [ `sudo apt list | grep -ic clamav` -eq 0 ]; then
sudo apt-get install clamav
else
echo -n "[Clam AV]"
seperate
echo "Installed"
echo
fi
}

external() {
echo -n "[External Media]"
seperate
ls /media/$(ls /media | grep -v rom)
echo
}

scan() {
echo -n "[Dangerous File Locations]"
locate john samba netcat metasploit nmap openssh wiresharl nessus aircrack snort crack
#Sort by sbin to locate executables
}

run() {
badfile
hosts
backdoor
firewall
kernel
startup
rootlogin
passwords
shadow
updates
admins
sudoers
guest
autologin
greeter
policy
program
viruses
}
