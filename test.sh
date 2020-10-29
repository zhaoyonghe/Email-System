cd $1
for i in inputs/*
do
	echo =================== $i ===================
	bin/mail-in <$i
done