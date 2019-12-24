* 创建数据库
```
CREATE DATABASE game;
```
* 创建数据保留策略
```
CREATE RETENTION POLICY "seven_days" ON "game" DURATION 7d REPLICATION 1 DEFAULT;
CREATE RETENTION POLICY "three_month" ON "game" DURATION 90d REPLICATION 1
CREATE RETENTION POLICY "a_year" ON "game" DURATION 52w REPLICATION 1
```


* 创建连续查询
```
CREATE CONTINUOUS QUERY "cq_1m" ON "game" BEGIN  SELECT mean(*) INTO "game"."three_month".:MEASUREMENT FROM /.*/ GROUP BY time(1m),region,server,node END
CREATE CONTINUOUS QUERY "cq_1h" ON "game" BEGIN  SELECT mean(*) INTO "game"."a_year".:MEASUREMENT FROM /.*/ GROUP BY time(1h),region,server,node END
```

// drop continuous query cq_1m on 
// CREATE CONTINUOUS QUERY "cq_1m" ON "game" BEGIN SELECT mean("count") AS "count",mean("oneMinute") AS "oneMinute" ,mean("fiveMinute") AS "fiveMinute",mean("fifteenMinute") AS "fifteenMinute" INTO "three_month"."sendBytes" FROM "sendBytes" GROUP BY time(10s),region,server,node END