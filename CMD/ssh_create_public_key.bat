powershell.exe -ExecutionPolicy Bypass -File install-sshd.ps1
netsh adbfirewall firewall add rule name=sshd dir=in action=allow protocol=TCP localport=22
sc config sshd start=auto
net start sshd
netstat -an | findstr :22

ssh-keygen -t rsa -f id_rsa