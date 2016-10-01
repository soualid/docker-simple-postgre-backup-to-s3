#!/bin/sh
mkdir -p /root/.aws/ && \
  echo -e "[default]\naws_access_key_id = $AWS_ACCESS_KEY\naws_secret_access_key = $AWS_SECRET" > /root/.aws/credentials 
#echo $PG_HOST:$PG_PORT:$PG_USER:$PG_PASS > ~/.pgpass && chmod 600 ~/.pgpass
export PGPASSWORD=$PG_PASS
echo pass: $PGPASSWORD
currentDate=$(date +%F_%R)
currentDate=${currentDate/:/-}
REMOTE=${REMOTE/-currentdate-/$currentDate}
pg_dump -U $PG_USER -d $DB_NAME -p $PG_PORT -h $PG_HOST | gzip > $DB_NAME.dump.gz
aws s3 cp $DB_NAME.dump.gz $REMOTE/$DB_NAME.dump.gz
rm $DB_NAME.dump.gz