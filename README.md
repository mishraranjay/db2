# db2
# Option 1 - with defined database
docker run -itd --name c-db2 --privileged=true -p 50000:50000 \
    -e LICENSE=accept \
    -e DB2INST1_PASSWORD=<password> \
    -e DBNAME=testdb \
    db2

# Option 2 - with sampledb
docker run -itd --name c-db2 --privileged=true -p 50000:50000 \
    -e LICENSE=accept \
    -e DB2INST1_PASSWORD=$DB2_PASSWORD \
    -e SAMPLEDB=true \
    db2
