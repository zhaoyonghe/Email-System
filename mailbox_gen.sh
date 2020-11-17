#!/bin/bash

mkdir /home/mailbox

input=("addleness" "analects" "annalistic" "anthropomorphologically" "blepharosphincterectomy" "corector" "durwaun" "dysphasia" "encampment" "endoscopic" "exilic" "forfend" "gorbellied" "gushiness" "muermo" "neckar" "outmate" "outroll" "overrich" "philosophicotheological" "pockwood" "polypose" "refluxed" "reinsure" "repine" "scerne" "starshine" "unauthoritativeness" "unminced" "unrosed" "untranquil" "urushinic" "vegetocarbonaceous" "wamara" "whaledom")

for i in ${input[@]}
do
	#random="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)"
	random="asd"
    echo "================================================================="
    echo "gen {$i}   {$random}"
    echo "================================================================="
	groupadd $i
	useradd -s /bin/bash -m -d /home/mailbox/$i  -g $i $i
	echo -e "$random\n$random\n" | passwd $i

done