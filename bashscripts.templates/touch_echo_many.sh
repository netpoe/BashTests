COUNT=10
while (( COUNT > 0 ))
do
	touch sql-5-$COUNT.js
	echo -e "var sqltest = require(\"./fw-sqltests.js\");\n\n\nvar tasks = [\n\n ];\n\n\nsqltest.init(tasks);" > sql-5-$COUNT.js
	(( COUNT -- ))
done
