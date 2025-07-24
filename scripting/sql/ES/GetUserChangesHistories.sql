-- db2 -vtf C:\Users\mingtungl\sql\GetUserChangesHistories.sql -z C:\Users\mingtungl\out\GetUserChangesHistories.txt > null

-- Database: OLAP
-- Frequency: daily at least once
-- Type: reporting
-- Parameters: start, end are timestamps
-- ${startSrvTime}$ 	= 2021-10-31-18.00.00  -- 2021-11-01-00.00.00 Spainishlocal  time
-- ${endSrvTime}$		= 2021-12-31-0.00.00 (yyyy-mm-dd-hh.mm.ss)

-- 
-- 1. PopulateSpainTempTableForUserChanges
--
DECLARE GLOBAL TEMPORARY TABLE SESSION.temp_users
(
    userintid    INTEGER NOT NULL,
    when         TIMESTAMP NOT NULL,
    oldvalue     VARCHAR(100) NOT NULL,
    newvalue     VARCHAR(100) NOT NULL,
    updatedfield SMALLINT NOT NULL,
    updatedprop SMALLINT NOT NULL,
    updateid BIGINT NOT NULL,
    updatetype INTEGER NOT NULL,
    limit_type INTEGER NOT NULL
)
WITH REPLACE ON COMMIT PRESERVE ROWS NOT LOGGED;


CREATE INDEX SESSION.TMP_IDX_USERS ON SESSION.temp_users(userintid);

INSERT INTO SESSION.temp_users
WITH T AS (
SELECT userintid, updatedfield, updatetype, oldvalue, newvalue, when, updateid
FROM db2admin.userchanges
WHERE updatedfield IN (1,2,3,5,6,7,10,11,12,18,21,25,26,27,28,34)
   AND when BETWEEN '${startSrvTime}$' AND cast('${endSrvTime}$' as TIMESTAMP) - 1 microsecond
   AND UPDATETYPE IN (1,6,7,8,9,21,22,25,28,32,33,36,37,38,40,55,57,70,78,107,108,111,41,43,44,45,235,237,249)
   AND oldvalue != newvalue
   and userintid in (${userIntIds}$)
)
SELECT t.userintid, when, oldvalue, newvalue, updatedfield, 0 updatedprop, updateid, updatetype, 0 limit_type
FROM T
UNION ALL
	SELECT userintid,propertywhen,'' oldvalue,
		CASE WHEN propertyid=46 or propertyid=6 THEN CAST(propertyint AS VARCHAR(100)) ELSE propertystr END
		, 0 updatedfield,propertyid, 0 updateid, 0 updatetype, 0 limit_type
	FROM db2admin.userpropaudit
	WHERE PROPERTYWHEN BETWEEN '${startSrvTime}$' AND cast('${endSrvTime}$' as TIMESTAMP) - 1 microsecond
	  AND PROPERTYID IN (6,44,45,46,53)
	  and userintid in (${userIntIds}$)
UNION ALL
	SELECT userintid, completed, CAST(oldlimit AS VARCHAR(100)), CAST(newlimit AS VARCHAR(100))
		, 0 updatedfield, 0 updatedprop, 0 updateid, 0 updatetype, type
	FROM db2admin.limitsaudit
	WHERE completed BETWEEN '${startSrvTime}$' AND cast('${endSrvTime}$' as TIMESTAMP) - 1 microsecond
	  AND status='A'
	  and userintid in (${userIntIds}$)
;

--
-- 2. GetHistoricUserChangesForRU
--
SELECT userintid, updatedfield, updatetype, updateid, adminintid, when, oldvalue, newvalue
FROM db2admin.USERCHANGES uc
where updatedfield in (5,11,12,21,27,28)
  and exists (select 1 from db2admin.UserFirsttimeEvents fte where licenseid=128 and uc.userIntId=fte.userintid and uc.when >= fte.when)
  and userintid in (select distinct userintid from SESSION.temp_users)
order by userintid, when, updateid
;

-- 3a --
-- compileSpainUsersReportFromDbResults -> GetSpainUserDetailsForPeriod -- Daily
--
WITH T AS
(
    SELECT ufte.userintid,ufte.when as when1stRmOk,userid
		,t.when,t.oldvalue,t.newvalue,t.updatedfield,t.updatetype,t.updatedprop,t.updateid
		,u.flags,u.flags2,u.privileges,u.privileges2
        ,ROW_NUMBER() OVER(PARTITION BY u.userintid order by t.when ) rownum
    FROM db2admin.users u
	JOIN db2admin.USERFIRSTTIMEEVENTS ufte ON (u.userIntId=ufte.userIntId+0 and ufte.licenseId=128 and ufte.when <= '${endSrvTime}$')
	INNER JOIN SESSION.temp_users t ON u.userintid+0=t.userintid
)
SELECT userintid,when1stRmOk,updateid,when,oldvalue,newvalue,updatedfield,updatedtype,updatedprop,flags,flags2,privileges,privileges2
    --,CASE WHEN rownum=1 THEN (SELECT propertystr from db2admin.userproperties WHERE userintid=T.userintid+0 AND propertyid=45) ELSE '' END AS tax_region -- eUserPropertySpainTaxRegion
    --,CASE WHEN rownum=1 THEN (SELECT propertyint from db2admin.userproperties WHERE userintid=T.userintid+0 AND propertyid=46) ELSE 0 END AS document_type -- eUserPropertySpainPersonalIdType int value
    --,CASE WHEN rownum=1 THEN (SELECT propertystr from db2admin.userproperties WHERE userintid=T.userintid+0 AND propertyid=46) ELSE '' END AS other_doc_type -- eUserPropertySpainPersonalIdType str value
    --,CASE WHEN rownum=1 THEN (SELECT propertyint from db2admin.userproperties WHERE userintid=T.userintid+0 AND propertyid=6) ELSE 0 END AS negativeCategory -- eNegativeCategory
    --,CASE WHEN rownum=1 THEN (SELECT propertystr from db2admin.userproperties WHERE userintid=T.userintid+0 AND propertyid=53) ELSE '' END AS citizenship -- eUserPropertyCitizenship
    --,CASE WHEN rownum=1 THEN (SELECT weeklylimit from db2admin.userlimits WHERE userintid=T.userintid+0 AND type=1) ELSE 0 END AS daily_deposit_limit
    --,CASE WHEN rownum=1 THEN (SELECT weeklylimit from db2admin.userlimits WHERE userintid=T.userintid+0 AND type=7) ELSE 0 END AS weekly_deposit_limit
    --,CASE WHEN rownum=1 THEN (SELECT weeklylimit from db2admin.userlimits WHERE userintid=T.userintid+0 AND type=30) ELSE 0 END AS monthly_deposit_limit
FROM T
ORDER BY userintid,when
;

-- 3b --
-- compileSpainUsersReportFromDbResults -> GetSpainUserDetailsForPeriod -- Monthly
--
WITH T AS
(
    SELECT ufte.userintid,ufte.when as when1stRmOk,userid
		,t.when,t.oldvalue,t.newvalue,t.updatedfield,t.updatetype,t.updatedprop,t.updateid
		,u.flags,u.flags2,u.privileges,u.privileges2
        ,ROW_NUMBER() OVER(PARTITION BY u.userintid order by t.when ) rownum
    FROM db2admin.users u
	JOIN db2admin.USERFIRSTTIMEEVENTS ufte ON (u.userIntId=ufte.userIntId+0 and ufte.licenseId=128 and ufte.when <= '${endSrvTime}$')
	LEFT JOIN SESSION.temp_users t ON u.userintid+0=t.userintid
	WHERE u.userintid in (${userIntIds}$)
)
--SELECT userintid,when1stRmOk ,when,oldvalue,newvalue,updatedfield,updatedprop,updateid,flags,flags2,privileges,privileges2
SELECT userintid,when1stRmOk,updateid,when,oldvalue,newvalue,updatedfield,updatedtype,updatedprop,flags,flags2,privileges,privileges2
    --,CASE WHEN rownum=1 THEN (SELECT propertystr from db2admin.userproperties WHERE userintid=T.userintid+0 AND propertyid=45) ELSE '' END AS tax_region -- eUserPropertySpainTaxRegion
    --,CASE WHEN rownum=1 THEN (SELECT propertyint from db2admin.userproperties WHERE userintid=T.userintid+0 AND propertyid=46) ELSE 0 END AS document_type -- eUserPropertySpainPersonalIdType int value
    --,CASE WHEN rownum=1 THEN (SELECT propertystr from db2admin.userproperties WHERE userintid=T.userintid+0 AND propertyid=46) ELSE '' END AS other_doc_type -- eUserPropertySpainPersonalIdType str value
    --,CASE WHEN rownum=1 THEN (SELECT propertyint from db2admin.userproperties WHERE userintid=T.userintid+0 AND propertyid=6) ELSE 0 END AS negativeCategory -- eNegativeCategory
    --,CASE WHEN rownum=1 THEN (SELECT propertystr from db2admin.userproperties WHERE userintid=T.userintid+0 AND propertyid=53) ELSE '' END AS citizenship -- eUserPropertyCitizenship
    --,CASE WHEN rownum=1 THEN (SELECT weeklylimit from db2admin.userlimits WHERE userintid=T.userintid+0 AND type=1) ELSE 0 END AS daily_deposit_limit
    --,CASE WHEN rownum=1 THEN (SELECT weeklylimit from db2admin.userlimits WHERE userintid=T.userintid+0 AND type=7) ELSE 0 END AS weekly_deposit_limit
    --,CASE WHEN rownum=1 THEN (SELECT weeklylimit from db2admin.userlimits WHERE userintid=T.userintid+0 AND type=30) ELSE 0 END AS monthly_deposit_limit
FROM T
ORDER BY userintid,when
;

drop table SESSION.temp_users;



127422897, 139842268