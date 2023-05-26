HOST='webcritech.jrc.ec.europa.eu' 
USER='userTAD' 
PASSWD='T4d$Ftp!3cml'

ftp -p -n $HOST  << EOF
quote USER $USER 
quote PASS $PASSWD
dir
quit
EOF
