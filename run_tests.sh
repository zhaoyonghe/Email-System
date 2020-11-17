#!/bin/bash

ARGC=$#
if [[ $ARGC -eq 1 ]]; then
    TREE=$1
else
    echo "Please provide a tree to test"
    exit 1
fi

cd $TREE

users1=("analects" "annalistic" "anthropomorphologically" "blepharosphincterectomy" "corector" "durwaun" "dysphasia" "encampment" "endoscopic" "exilic" "forfend" "gorbellied" "gushiness" "muermo" "neckar" "outmate" "outroll" "overrich" "philosophicotheological" "pockwood" "polypose" "refluxed" "reinsure" "repine" "scerne" "starshine" "unauthoritativeness" "unminced" "unrosed" "untranquil" "urushinic" "vegetocarbonaceous" "wamara" "whaledom")
users2=("addleness" "analects" "annalistic" "anthropomorphologically" "blepharosphincterectomy" "corector" "durwaun" "dysphasia" "encampment" "endoscopic" "exilic" "forfend" "gorbellied" "gushiness" "muermo" "neckar" "outmate" "outroll" "overrich" "philosophicotheological" "pockwood" "polypose" "refluxed" "reinsure" "repine" "scerne" "starshine" "unauthoritativeness" "unminced" "unrosed" "untranquil" "urushinic" "vegetocarbonaceous" "wamara" "whaledom")

for i in ../inputs/*
do

	echo "*********************************************"
	echo "Test $i"

	# run the test
	bin/mail-in < $i > /dev/null 2>&1
	#sudo valgrind --log-file=log.txt bin/mail-in < $i

	# get the filename
	filename="${i:10}"
	# echo $filename

	# compare the outpus
	icdiff -r mail/ ../outputs/$filename/

	# permission tests
	NUM=1
	NUM=$(($NUM*$(su addleness --shell /bin/bash -c "rm -rf bin 2>&1 | grep \"Permission denied\" | wc -l")))
	NUM=$(($NUM*$(su addleness --shell /bin/bash -c "rm -rf mail 2>&1 | grep \"Permission denied\" | wc -l")))
	for j in ${users1[@]}
	do
		#su addleness -c "whoami"
		#echo $j
		#su addleness -c "pwd"
		#su addleness -c "cd mail/$j/"
		#su addleness -c "ls mail/$j/"
		#su addleness -c "rm -rf mail/$j/"
		NUM=$(($NUM*$(su addleness --shell /bin/bash -c "cd mail/$j/ 2>&1 | grep \"Permission denied\" | wc -l")))
		NUM=$(($NUM*$(su addleness --shell /bin/bash -c "ls mail/$j/ 2>&1 | grep \"Permission denied\" | wc -l")))
		NUM=$(($NUM*$(su addleness --shell /bin/bash -c "rm -rf mail/$j/ 2>&1 | grep \"Permission denied\" | wc -l")))
	done
	# echo $NUM
	if [ $NUM -ne 70 ]; then
		echo "PERMISSION ERROR DETECTED AT TEST ${TEST}!"
	fi

	# wipe the newly created files
	find mail -type f -print0 | xargs -0 rm &>/dev/null

	for j in ${users2[@]}
	do
		echo -e "MAIL FROM:<wamara>\nRCPT to:<$j>\nDATA\n....\n." | bin/mail-in > /dev/null
		# ls
		# total 0
		# xxxx   00001
		NUM=$(($NUM+$(su $j --shell /bin/bash -c "ls -l mail/$j/ 2>&1 | wc -l")-2))
		# cd
		NUM=$(($NUM+$(su $j --shell /bin/bash -c "cd mail/$j/ 2>&1 | wc -l")))
		# write
		NUM=$(($NUM+$(su $j --shell /bin/bash -c "cat mail/$j/00001 2>&1 | wc -l")-4))
		NUM=$(($NUM+$(su $j --shell /bin/bash -c "echo asdfdsaf >> mail/$j/00001 2>&1 | wc -l")))
		NUM=$(($NUM+$(su $j --shell /bin/bash -c "cat mail/$j/00001 2>&1 | wc -l")-5))
		# delete
		NUM=$(($NUM+$(su $j --shell /bin/bash -c "rm mail/$j/00001 2>&1 | wc -l")))
		NUM=$(($NUM+$(su $j --shell /bin/bash -c "ls -l mail/$j/ 2>&1 | wc -l")-1))
	done
	if [ $NUM -ne 70 ]; then
		echo "PERMISSION ERROR DETECTED AT TEST ${TEST}!"
	fi

	# wipe the newly created files
	find mail -type f -print0 | xargs -0 rm &>/dev/null
	
	echo "*********************************************"
	echo ""
done