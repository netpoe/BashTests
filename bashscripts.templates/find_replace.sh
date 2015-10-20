COUNT=10
while (( COUNT > 0 ))
do
	find .guides/sqltests.js -type f -name "sql-1-$COUNT.js" -exec sed -i ' ' "s@sqlchallenges@sql-1-$COUNT@g" {} +
	(( COUNT -- ))
done