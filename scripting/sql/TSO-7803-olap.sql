-- db2 -vtf C:\Users\mingtungl\sql\GetUserChangesHistories.sql -z C:\Users\mingtungl\out\GetUserChangesHistories.txt > null

-- Database: OLAP
-- Frequency: daily at least once
-- Type: reporting
-- Parameters: start, end are timestamps

-- 
-- 1. PopulateSpainTempTableForUserChanges
--
DECLARE GLOBAL TEMPORARY TABLE SESSION.temp_users
(
    userintid    INTEGER NOT NULL,
    when         TIMESTAMP NOT NULL,
    oldvalue     VARCHAR(100) NOT NULL,
    newvalue     VARCHAR(100) NOT NULL,
    updated_field SMALLINT NOT NULL,
    updated_prop SMALLINT NOT NULL,
    updateid BIGINT NOT NULL,
    limit_type INTEGER NOT NULL
)
WITH REPLACE ON COMMIT PRESERVE ROWS NOT LOGGED;


CREATE INDEX SESSION.TMP_IDX_USERS ON SESSION.temp_users(userintid);

INSERT INTO SESSION.temp_users
WITH T AS (
SELECT userintid, updatedfield, oldvalue, newvalue, when, updateid
FROM userchanges
WHERE updatedfield IN (1,2,3,5,6,7,10,11,12,18,21,25,26,27,28,34)
   AND when BETWEEN '2021-08-16 00:00:00' AND cast('2021-09-17 00:00:00' as TIMESTAMP) - 1 microsecond
   AND UPDATETYPE IN (1,6,7,8,9,21,22,25,28,32,33,36,37,38,40,55,57,70,78,107,108,111,41,43,44,45,235,237,249)
   AND oldvalue != newvalue
   AND userintid in (105437353,124360749)
)
SELECT t.userintid, when, oldvalue, newvalue, updatedfield, 0 updated_prop, updateid, 0 limit_type
FROM T
UNION ALL
SELECT userintid,propertywhen,'' oldvalue,
    CASE WHEN propertyid=46 or propertyid=6 THEN CAST(propertyint AS VARCHAR(100)) ELSE propertystr END
    , 0 updated_field,propertyid, 0 updateid, 0 limit_type
FROM userpropaudit
WHERE PROPERTYWHEN BETWEEN '2021-08-16 00:00:00' AND cast('2021-09-17 00:00:00' as TIMESTAMP) - 1 microsecond
  AND PROPERTYID IN (6,44,45,46,53)
UNION ALL
SELECT userintid, completed, CAST(oldlimit AS VARCHAR(100)), CAST(newlimit AS VARCHAR(100))
    , 0 updated_field, 0 updated_prop, 0 updateid, type
FROM limitsaudit
WHERE completed BETWEEN '2021-08-16 00:00:00' AND cast('2021-09-17 00:00:00' as TIMESTAMP) - 1 microsecond
  AND status='A'
;

--
-- 2. GetUserChangesHistories
--
SELECT userintid, updatedfield, updatetype, updateid, adminintid, when, oldvalue, newvalue
FROM USERCHANGES uc
where updatedfield in (5,11,12,21,27,28)
  and exists (select 1 from UserFirsttimeEvents fte where licenseid=131072 and uc.userIntId=fte.userintid and uc.when >= fte.when)
  and userintid in (105437353,124360749) --(select distinct userintid from SESSION.temp_users)
order by userintid,when,updateid
;

drop table SESSION.temp_users;