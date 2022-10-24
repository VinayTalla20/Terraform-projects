add-content -path C:/Users/VinayT/.ssh/config -value @'

Host ec2
   HostName ${hostname}
   User ${user}
   IdentityFile ${identityfile}
'@