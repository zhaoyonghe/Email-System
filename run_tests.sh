#!/bin/bash

users=("analects" "annalistic" "anthropomorphologically" "blepharosphincterectomy" "corector" "durwaun" "dysphasia" "encampment" "endoscopic" "exilic" "forfend" "gorbellied" "gushiness" "muermo" "neckar" "outmate" "outroll" "overrich" "philosophicotheological" "pockwood" "polypose" "refluxed" "reinsure" "repine" "scerne" "starshine" "unauthoritativeness" "unminced" "unrosed" "untranquil" "urushinic" "vegetocarbonaceous" "wamara" "whaledom")

cd $1

for i in inputs/*
do

	echo "*********************************************"
	echo "Test $i"

	# run the test
	bin/mail-in < $i > /dev/null 2>&1

	# get the filename
	filename="${i:7}"
	echo $filename

	# compare the outpus
	icdiff -r mail/ ../outputs/$filename/

	NUM=1
	NUM=$(($NUM*$(su addleness -c "rm -rf bin 2>&1 | grep \"Permission denied\" | wc -l")))
	NUM=$(($NUM*$(su addleness -c "rm -rf mail 2>&1 | grep \"Permission denied\" | wc -l")))

	for j in ${users[@]}
	do
		#su addleness -c "whoami"
		#echo $j
		#su addleness -c "pwd"
		#su addleness -c "cd mail/$j/"
		#su addleness -c "ls mail/$j/"
		#su addleness -c "rm -rf mail/$j/"
		NUM=$(($NUM*$(su addleness -c "cd mail/$j/ 2>&1 | grep \"Permission denied\" | wc -l")))
		NUM=$(($NUM*$(su addleness -c "ls mail/$j/ 2>&1 | grep \"Permission denied\" | wc -l")))
		NUM=$(($NUM*$(su addleness -c "rm -rf mail/$j/ 2>&1 | grep \"Permission denied\" | wc -l")))
	done
	echo $NUM
	if [ $NUM -ne 70 ]; then
		echo "PERMISSION ERROR DETECTED AT TEST ${TEST}!"
	fi

	# wipe the newly created files
	find mail -type f -print0 | xargs -0 rm &>/dev/null
	
	echo "*********************************************"
	echo ""
done

