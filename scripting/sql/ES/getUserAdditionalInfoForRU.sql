-- getUserAdditionalInfoForRU.sql
-- db2 -vtf C:\Users\mingtungl\sql\getUserAdditionalInfoForRU.sql -z C:\Users\mingtungl\out\getUserAdditionalInfoForRU.txt > null

-- DBM_Q_GET_SPAIN_USERS_REPORT_FOR_RU 1482 // 4ftt - reqId,isDaily,startTime,endTime
-- Database: OLAP
-- Frequency: daily at least once
-- Type: reporting
-- Parameters: start, end are timestamps
-- ${startPeriod}$ 	= 2021-10-31-18.00.00  -- 2021-11-01-00.00.00 Spainish local  time
-- ${currTime}$		= 2021-12-31-0.00.00 (yyyy-mm-dd-hh.mm.ss)

-- getDataForSpainRuReport()
-- 1 --
-- PopulateSpainTempTableForUserChanges
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
WITH T AS(
    SELECT userintid, updatedfield, oldvalue, newvalue, when, updateid
    FROM userchanges
    WHERE updatedfield IN (1,2,3,5,6,7,10,11,12,18,21,25,26,27,28,34)
    AND when BETWEEN '${startPeriod}$' AND cast('${currTime}$' as TIMESTAMP) - 1 microsecond
    AND UPDATETYPE IN (1,6,7,8,9,21,22,25,28,32,33,36,37,38,40,55,57,70,78,107,108,111,41,43,44,45,235,237,249)
    AND oldvalue != newvalue
    and userintid in (${uiids}$)
)
SELECT t.userintid, when, oldvalue, newvalue, updatedfield, 0 updated_prop, updateid, 0 limit_type
FROM T
UNION ALL

SELECT userintid,propertywhen,'' oldvalue,
    CASE WHEN propertyid=46 or propertyid=6 THEN CAST(propertyint AS VARCHAR(100)) ELSE propertystr END,
    0 updated_field,propertyid, 0 updateid, 0 limit_type
FROM userpropaudit
WHERE PROPERTYWHEN BETWEEN '${startPeriod}$' AND cast('${currTime}$' as TIMESTAMP) - 1 microsecond
 AND PROPERTYID IN (6,44,45,46,53)
 and userintid in (${uiids}$)

UNION ALL
SELECT userintid, completed, CAST(oldlimit AS VARCHAR(100)), CAST(newlimit AS VARCHAR(100)),
    0 updated_field, 0 updated_prop, 0 updateid, type
FROM limitsaudit
WHERE completed BETWEEN '${startPeriod}$' AND cast('${currTime}$' as TIMESTAMP) - 1 microsecond
 AND status='A'
 and userintid in (${uiids}$)
;

-- 2 -- populate user additional data from all history
-- getUserAdditionalInfoForRU(*this, end, isDailyNotMonthly, usersAdditionalInfo);
-- GetHistoricUserChangesForRU
SELECT userintid, updatedfield, updatetype, updateid, adminintid, when, oldvalue, newvalue
FROM USERCHANGES uc
where updatedfield in (5,11,12,21,27,28) -- eFieldType: fieldCountry,fieldPrivileges,fieldFlags,fieldPrivileges2,fieldFiscalCode,fieldFlags2
 and exists (select 1 from UserFirsttimeEvents fte where licenseid=128 and uc.userIntId=fte.userintid and uc.when >= fte.when)
-- if isDailyNotMonthly = true,
 and userintid in (${uiids}$) --(select distinct userintid from SESSION.temp_users)
order by userintid, when, updateid;

-- 3 -- Daily
-- compileSpainUsersReportFromDbResults()
-- GetSpainUserDetailsForPeriod stmt(man, isDailyNotMonthly);
WITH T AS (
    SELECT ufte.userintid,ufte.when as when1stRmOk,t.when,userid,oldvalue,newvalue,updated_field,updated_prop,updateid
    ,flags,flags2,privileges,privileges2
    ,ROW_NUMBER() OVER(PARTITION BY u.userintid order by t.when ) rownum
    FROM
    users u JOIN USERFIRSTTIMEEVENTS ufte ON (u.userIntId=ufte.userIntId+0 and ufte.licenseId=128 and ufte.when <= '${currTime}$')
    -- if isDailyNotMonthly ?  INNER :  LEFT
    INNER JOIN SESSION.temp_users t ON u.userintid+0=t.userintid
    -- else LEFT JOIN SESSION.temp_users t ON u.userintid+0=t.userintid
)
SELECT userintid,userid,when1stRmOk,when,oldvalue,newvalue,updated_field,updated_prop,updateid
    ,CASE WHEN rownum=1 THEN (SELECT propertyint FROM userproperties WHERE userintid=T.userintid+0 AND propertyid=46) ELSE 0 END AS document_type
    ,CASE WHEN rownum=1 THEN (SELECT propertystr FROM userproperties WHERE userintid=T.userintid+0 AND propertyid=46) ELSE '' END AS other_doc_type
    ,flags,flags2,privileges,privileges2
    ,CASE WHEN rownum=1 THEN (SELECT propertyint FROM userproperties WHERE userintid=T.userintid+0 AND propertyid=6) ELSE 0 END AS negativeCategory
FROM T
where userintid in (${uiids}$)
ORDER BY userintid,when;

-- 3 -- Monthly
-- compileSpainUsersReportFromDbResults()
-- GetSpainUserDetailsForPeriod stmt(man, isDailyNotMonthly);
WITH T AS (
    SELECT ufte.userintid,ufte.when as when1stRmOk,t.when,userid,oldvalue,newvalue,updated_field,updated_prop,updateid
    ,flags,flags2,privileges,privileges2
    ,ROW_NUMBER() OVER(PARTITION BY u.userintid order by t.when ) rownum
    FROM
    users u JOIN USERFIRSTTIMEEVENTS ufte ON (u.userIntId=ufte.userIntId+0 and ufte.licenseId=128 and ufte.when <= '${currTime}$')
    LEFT JOIN SESSION.temp_users t ON u.userintid+0=t.userintid
)
SELECT userintid,userid,when1stRmOk,when,oldvalue,newvalue,updated_field,updated_prop,updateid
    ,CASE WHEN rownum=1 THEN (SELECT propertyint FROM userproperties WHERE userintid=T.userintid+0 AND propertyid=46) ELSE 0 END AS document_type
    ,CASE WHEN rownum=1 THEN (SELECT propertystr FROM userproperties WHERE userintid=T.userintid+0 AND propertyid=46) ELSE '' END AS other_doc_type
    ,flags,flags2,privileges,privileges2
    ,CASE WHEN rownum=1 THEN (SELECT propertyint FROM userproperties WHERE userintid=T.userintid+0 AND propertyid=6) ELSE 0 END AS negativeCategory
FROM T 
where userintid in (${uiids}$)
ORDER BY userintid,when;

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- GetHistoricPropAuditForRU
-- No inputs
--
WITH H AS
(
    SELECT UPA.*, (SELECT UPA2.WHENCHANGED
                    FROM USERPROPAUDIT UPA2
                    WHERE UPA2.USERINTID = FTE.USERINTID
                    AND UPA2.PROPERTYID = UPA.PROPERTYID
                    AND UPA2.WHENCHANGED < UPA.WHENCHANGED
                    ORDER BY 1 DESC
                    FETCH FIRST 1 ROWS ONLY) AS PREV_WHENCHANGED
    FROM USERPROPAUDIT UPA
    JOIN USERFIRSTTIMEEVENTS FTE ON UPA.USERINTID = FTE.USERINTID AND FTE.LICENSEID = 128
    --isDailyNotMonthly ? AND UPA.USERINTID in(select distinct USERINTID from SESSION.temp_users) : ""
    AND UPA.WHENCHANGED >= FTE.WHEN
    AND UPA.PROPERTYID IN(6, 46, 53)
    AND UPA.USERINTID in (${uiids}$)
),
H2 AS
(
    SELECT H.*
        ,UPA.RECORDID     AS RECORDID_PREV
        ,UPA.ADMININTID   AS ADMININTID_PREV
        ,UPA.COMMENT      AS COMMENT_PREV
        ,UPA.PROPERTYINT  AS PROPERTYINT_PREV
        ,UPA.PROPERTYSTR  AS PROPERTYSTR_PREV
        ,UPA.PROPERTYWHEN AS PROPERTYWHEN_PREV
        ,UPA.ACTION       AS ACTION_PREV
        ,UPA.APPLOGINID   AS APPLOGINID_PREV
        ,UPA.WHENCHANGED  AS WHENCHANGED_PREV
        ,ROW_NUMBER() OVER(PARTITION BY H.USERINTID, H.PROPERTYID, UPA.WHENCHANGED ORDER BY UPA.RECORDID DESC,H.RECORDID DESC) AS NUM
    FROM H LEFT JOIN USERPROPAUDIT UPA ON H.USERINTID = UPA.USERINTID
    AND H.PROPERTYID = UPA.PROPERTYID
    AND H.PREV_WHENCHANGED = UPA.WHENCHANGED
)
SELECT RECORDID, ADMININTID, COMMENT, USERINTID, PROPERTYID
    , PROPERTYINT, PROPERTYSTR, PROPERTYWHEN, ACTION, APPLOGINID
    , WHENCHANGED, RECORDID_PREV, ADMININTID_PREV, COMMENT_PREV, PROPERTYINT_PREV
    , PROPERTYSTR_PREV, PROPERTYWHEN_PREV, ACTION_PREV, APPLOGINID_PREV, WHENCHANGED_PREV
FROM H2
WHERE NUM = 1
 and userintid in (${uiids}$)
ORDER BY USERINTID, WHENCHANGED, RECORDID
;

drop table SESSION.temp_users;