#!/bin/bash

groupadd mailer
useradd -s /usr/bin/false -m -d /home/mailer -g mailer mailer

groupadd mailuser

chown root:root "$1"
chmod 755 "$1"
chown root:root "$1"/bin
chmod 755 "$1"/bin
chown root:root "$1"/mail
chmod 755 "$1"/mail

chown mailer:mailuser "$1"/bin/mail-in
chmod 6555 "$1"/bin/mail-in
chown mailer:mailer "$1"/bin/mail-out
chmod 100 "$1"/bin/mail-out

cd "$1"

users=("addleness" "analects" "annalistic" "anthropomorphologically" "blepharosphincterectomy" "corector" "durwaun" "dysphasia" "encampment" "endoscopic" "exilic" "forfend" "gorbellied" "gushiness" "muermo" "neckar" "outmate" "outroll" "overrich" "philosophicotheological" "pockwood" "polypose" "refluxed" "reinsure" "repine" "scerne" "starshine" "unauthoritativeness" "unminced" "unrosed" "untranquil" "urushinic" "vegetocarbonaceous" "wamara" "whaledom")

for i in ${users[@]}
do
    chown mailer:"$i" mail/"$i"
    chmod 770 mail/"$i"
    usermod -a -G mailuser "$i"
done