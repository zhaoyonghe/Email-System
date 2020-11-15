cd $1

for i in inputs/*
do

	echo "*********************************************"
	echo "Test $i"

	# run the test
	valgrind --log-file=log.txt bin/mail-in < $i > /dev/null 2>&1

	# check for memory leaks
	LEAK=$(cat "log.txt" | grep "ERROR SUMMARY: 0 errors" | wc -l)
	rm log.txt
   	if [ $LEAK -eq 0 ]; then
        	echo "[Grader] MEMORY LEAK DETECTED AT TEST ${TEST}!"
    	fi


	# get the filename
	filename="${i:7}"
	echo $filename

	# compare the outpus
	icdiff -r mail/ ../outputs/$filename/

	# wipe the newly created files
	find mail -type f -print0 | xargs -0 rm &>/dev/null
	
	echo "*********************************************"
	echo ""
done

