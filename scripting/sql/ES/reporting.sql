-- ES: reporting.sql

-- 2 --
-- PopulateSpainTempTableForUserChanges
--

DECLARE GLOBAL TEMPORARY TABLE SESSION.temp_users
(
    userintid     INTEGER NOT NULL,
    when          TIMESTAMP NOT NULL,
    oldvalue      VARCHAR(100) NOT NULL,
    newvalue      VARCHAR(100) NOT NULL,
    updated_field SMALLINT NOT NULL,
    updated_type  SMALLINT NOT NULL,
    updated_prop  SMALLINT NOT NULL,
    updateid      BIGINT NOT NULL,
    limit_type    INTEGER NOT NULL
)
WITH REPLACE ON COMMIT PRESERVE ROWS NOT LOGGED;


CREATE INDEX SESSION.TMP_IDX_USERS ON SESSION.temp_users(userintid);

INSERT INTO SESSION.temp_users
WITH T AS
(
	SELECT userintid, updatedfield, updatetype, oldvalue, newvalue, when, updateid
	from db2admin.userchanges
	WHERE updatedfield IN (1,2,3,5,6,7,10,11,12,18,21,25,26,27,28,34)
	 AND when BETWEEN '2021-10-31-18.00.00' --'${startPeriod_ET}$'
	          AND cast('2022-04-01-0.00.00'  --'${currTime_ET}$'
				   as TIMESTAMP) - 1 microsecond
	--AND UPDATETYPE IN (1,6,7,8,9,21,22,25,28,32,33,36,37,38,40,41,43,44,45,55,57,70,78,107,108,111,235,237,249) -- currently used in code
	AND UPDATETYPE IN (1,6,7,8,9,21,22,25,28,32,33,36,37,38,40,41,43,44,45,55,57,70,78,107,108,111,235,237,249,50,51,56,57,68,72,73,74,76,77,83,86,87,96,100,130) -- for testing
	AND oldvalue != newvalue
)
SELECT t.userintid, when, oldvalue, newvalue, updatedfield, t.updatetype, 0 updated_prop, updateid, 0 limit_type
FROM T
WHERE userintid=133895843
UNION ALL
SELECT userintid,propertywhen,'' oldvalue,
    CASE WHEN propertyid=46 or propertyid=6 THEN CAST(propertyint AS VARCHAR(100)) ELSE propertystr END
    , 0 updated_field,0 update_type, propertyid, 0 updateid, 0 limit_type
from db2admin.userpropaudit
WHERE PROPERTYWHEN BETWEEN '2021-10-31-18.00.00' --'${startPeriod_ET}$'
					AND cast('2022-04-01-0.00.00'  --'${currTime_ET}$'
					as TIMESTAMP) - 1 microsecond
  AND PROPERTYID IN (6,44,45,46,53)
UNION ALL
SELECT userintid, completed, CAST(oldlimit AS VARCHAR(100)), CAST(newlimit AS VARCHAR(100))
    , 0 updated_field,0 update_type, 0 updated_prop, 0 updateid, type
from db2admin.limitsaudit
WHERE completed BETWEEN '2021-10-31-18.00.00' --'${startPeriod_ET}$'
				AND cast('2022-04-01-0.00.00'  --'${currTime_ET}$'
				as TIMESTAMP) - 1 microsecond
  AND status='A'
;

select * from SESSION.temp_users WHERE userintid=133895843 order by when desc, updateid desc;

-- 3 --
-- GetHistoricUserChangesForRU
--
SELECT userintid, updatedfield, updatetype, updateid, adminintid, when, oldvalue, newvalue
from db2admin.USERCHANGES uc
where updatedfield in (5,11,12,21,27,28)
  and exists (select 1 from db2admin.UserFirsttimeEvents fte where licenseid=128 and uc.userIntId=fte.userintid and uc.when >= fte.when)
  and userintid=133895843 -- userintid in (select distinct userintid from SESSION.temp_users)
--order by userintid,when,updateid
order by when,updateid desc
;

-- 4a --
-- GetSpainUserDetailsForPeriod_Daily
--
WITH T AS
(
    SELECT ufte.userintid,ufte.when as when1stRmOk,t.when,userid,oldvalue,newvalue,updated_field,updated_prop,updateid,flags,flags2,privileges,privileges2
        --,ROW_NUMBER() OVER(PARTITION BY u.userintid order by t.when ) rownum
    FROM
    users u JOIN USERFIRSTTIMEEVENTS ufte ON (u.userIntId=ufte.userIntId+0 and ufte.licenseId=128 and ufte.when <= '2021-11-30-17.59.59')
	--users u JOIN USERFIRSTTIMEEVENTS ufte ON (u.userIntId=ufte.userIntId+0 and ufte.licenseId=128 and ufte.when <= '${endPeriod}}$')
    INNER JOIN SESSION.temp_users t ON u.userintid+0=t.userintid
    --where ufte.userintid=133895843
)
SELECT userintid,when1stRmOk ,when,oldvalue,newvalue,updated_field,updated_prop,updateid,flags,flags2,privileges,privileges2
    --,CASE WHEN rownum=1 THEN (SELECT propertystr from db2admin.userproperties WHERE userintid=T.userintid+0 AND propertyid=45) ELSE '' END AS tax_region -- eUserPropertySpainTaxRegion
    --,CASE WHEN rownum=1 THEN (SELECT propertyint from db2admin.userproperties WHERE userintid=T.userintid+0 AND propertyid=46) ELSE 0 END AS document_type -- eUserPropertySpainPersonalIdType int value
    --,CASE WHEN rownum=1 THEN (SELECT propertystr from db2admin.userproperties WHERE userintid=T.userintid+0 AND propertyid=46) ELSE '' END AS other_doc_type -- eUserPropertySpainPersonalIdType str value
    --,CASE WHEN rownum=1 THEN (SELECT propertyint from db2admin.userproperties WHERE userintid=T.userintid+0 AND propertyid=6) ELSE 0 END AS negativeCategory -- eNegativeCategory
    --,CASE WHEN rownum=1 THEN (SELECT propertystr from db2admin.userproperties WHERE userintid=T.userintid+0 AND propertyid=53) ELSE '' END AS citizenship -- eUserPropertyCitizenship
    --,CASE WHEN rownum=1 THEN (SELECT weeklylimit from db2admin.userlimits WHERE userintid=T.userintid+0 AND type=1) ELSE 0 END AS daily_deposit_limit
    --,CASE WHEN rownum=1 THEN (SELECT weeklylimit from db2admin.userlimits WHERE userintid=T.userintid+0 AND type=7) ELSE 0 END AS weekly_deposit_limit
    --,CASE WHEN rownum=1 THEN (SELECT weeklylimit from db2admin.userlimits WHERE userintid=T.userintid+0 AND type=30) ELSE 0 END AS monthly_deposit_limit
FROM T
WHERE userintid=133895843
--ORDER BY userintid,when
ORDER BY when desc, updateid desc
;


-- 2 --
-- GetSpainUserDetailsForPeriod_Monthly
--
WITH T AS
(
    SELECT ufte.userintid,ufte.when as when1stRmOk,t.when,userid,oldvalue,newvalue,updated_field,updated_prop,updateid,flags,flags2,privileges,privileges2
		--,ROW_NUMBER() OVER(PARTITION BY u.userintid order by t.when ) rownum
    FROM
    users u JOIN USERFIRSTTIMEEVENTS ufte ON (u.userIntId=ufte.userIntId+0 and ufte.licenseId=128 and ufte.when <= '2021-11-30-17.59.59')
	--users u JOIN USERFIRSTTIMEEVENTS ufte ON (u.userIntId=ufte.userIntId+0 and ufte.licenseId=128 and ufte.when <= '${endPeriod}}$')
    LEFT JOIN SESSION.temp_users t ON u.userintid+0=t.userintid
    --where ufte.userintid=133895843
)
SELECT userintid,when1stRmOk ,when,oldvalue,newvalue,updated_field,updated_prop,updateid,flags,flags2,privileges,privileges2
    --,CASE WHEN rownum=1 THEN (SELECT propertystr from db2admin.userproperties WHERE userintid=T.userintid+0 AND propertyid=45) ELSE '' END AS tax_region -- eUserPropertySpainTaxRegion
    --,CASE WHEN rownum=1 THEN (SELECT propertyint from db2admin.userproperties WHERE userintid=T.userintid+0 AND propertyid=46) ELSE 0 END AS document_type -- eUserPropertySpainPersonalIdType int value
    --,CASE WHEN rownum=1 THEN (SELECT propertystr from db2admin.userproperties WHERE userintid=T.userintid+0 AND propertyid=46) ELSE '' END AS other_doc_type -- eUserPropertySpainPersonalIdType str value
    --,CASE WHEN rownum=1 THEN (SELECT propertyint from db2admin.userproperties WHERE userintid=T.userintid+0 AND propertyid=6) ELSE 0 END AS negativeCategory -- eNegativeCategory
    --,CASE WHEN rownum=1 THEN (SELECT propertystr from db2admin.userproperties WHERE userintid=T.userintid+0 AND propertyid=53) ELSE '' END AS citizenship -- eUserPropertyCitizenship
    --,CASE WHEN rownum=1 THEN (SELECT weeklylimit from db2admin.userlimits WHERE userintid=T.userintid+0 AND type=1) ELSE 0 END AS daily_deposit_limit
    --,CASE WHEN rownum=1 THEN (SELECT weeklylimit from db2admin.userlimits WHERE userintid=T.userintid+0 AND type=7) ELSE 0 END AS weekly_deposit_limit
    --,CASE WHEN rownum=1 THEN (SELECT weeklylimit from db2admin.userlimits WHERE userintid=T.userintid+0 AND type=30) ELSE 0 END AS monthly_deposit_limit
FROM T
WHERE userintid=133895843
--ORDER BY userintid,when
ORDER BY when desc, updateid desc
;

drop table SESSION.temp_users;


SELECT userintid, updatedfield,UPDATETYPE,oldvalue, newvalue, when, updateid,ADMININTID
from db2admin.userchanges
WHERE updatedfield=12 -- IN (1,2,3,5,6,7,10,11,12,18,21,25,26,27,28,34)
 --when BETWEEN '2021-10-31-18.00.00' AND cast('2022-04-01-0.00.00' as TIMESTAMP) - 1 microsecond
 --AND UPDATETYPE IN (1,6,7,8,9,21,22,25,28,32,33,36,37,38,40,55,57,70,78,107,108,111,41,43,44,45,235,237,249)
 AND oldvalue != newvalue
 and userintid=133895843
order by when,updateid;
 
 
select * from db2admin.UserFirsttimeEvents where licenseid=128 and userIntId=133895843;
 
-- IT
select 	t.TRANSID, t.USERINTID, t.ADMININTID, t.WHEN, t.TRANSTYPE, t.OBJECTID, t.CHIPS, t.COMMENT, t.CURRENCY
	, p.PGADTRANSID, p.FLAGS, p.TRANSIDREPORTED, p.WHENREPORTED, p.BONUSPART, p.ERRCODE, p.XTRANSSTR, p.PGADMSG, p.PROPSTR
	--, u.licenseId
from db2admin.transacts t
inner join db2admin.PGADTRANSACTS p on t.transid=p.transidreported
--inner join db2admin.users u on u.userintid=t.userintid and u.licenseid=8
where t.transtype in (4300,4301,4302,4303,4304,4305,4306,4307,4308,4309 )-- in (4309,4002,4003,4004,4005,4033,4400,4401,4402,4403,3026,3060,3061,3062,3078,3082,5024,5031,5130,7130,7131,7132,7133,7134,7135,9023,9304,9322,9324,9327,7116,7117)
order by t.when desc
--fetch first 50 rows only
;

with ta as (
    select t.TRANSID, t.USERID, t.USERINTID, t.ADMININTID, t.WHEN, t.TRANSTYPE, t.OBJECTID, t.CHIPS, t.COMMENT, t.CURRENCY
        , row_number() over (partition by t.transtype order by t.when desc) rn
    from db2admin.transacts t
    where t.transtype in (7111,7112,7113,7114,7115,7116,7117,7118,7119,7120,7121,7122) --transid in(10805972894,10806078871,10806597162,10806654687,10806654687)
)
select * from ta where rn=1
;

select t.TRANSID, t.USERID, t.USERINTID, t.ADMININTID, t.WHEN, t.TRANSTYPE, t.OBJECTID, t.CHIPS, t.COMMENT, t.CURRENCY--
from db2admin.transacts t
where t.transid in (297086032820)
;

select * from db2admin.pgadtransacts pgad where pgad.TRANSIDREPORTED=10297086032820;

select gametype, currency, rake, addonrake, rebuyrake, tournflags2, siteid, (select property from db2admin.tournprops where tournid=t.tournid and locale=0 and proptype=41) as ffi
from db2admin.tourns t
where --siteid=2048  -- DK only
 startdatetime>='2022-05-01-00.00.00' and startdatetime<'2022-05-12-00.00.00' -- tournid=3020079821
  --and siteid=2048
;