COUNT=10
while (( COUNT > 0 ))
do
	touch file-$COUNT.ext
	mkdir dir-$COUNT.ext
	(( COUNT -- ))
done