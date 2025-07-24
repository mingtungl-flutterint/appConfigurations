/*SELECT UC.UPDATEID,UC.UPDATEDFIELD,UC.UPDATETYPE,UC.USERINTID,UC.ADMININTID,UC.WHEN,UC.OLDVALUE,UC.NEWVALUE,UC.APPLOGINID
FROM USERCHANGES UC
JOIN USERS U ON UC.USERINTID=U.USERINTID
JOIN USERFIRSTTIMEEVENTS FTE ON UC.USERINTID=FTE.USERINTID AND U.LICENSEID=FTE.LICENSEID
WHERE U.LICENSEID=${licenseId}$
 AND UC.WHEN >= FTE.WHEN
 --AND UC.WHEN BETWEEN ? AND ?
-- AND UC.UPDATEDFIELD IN (1,2,3,5,6,7,9,10,11,12,27,28,34,48)
ORDER BY UC.USERINTID,UC.WHEN,UC.UPDATEID;
*/

-- SelectUserFirstTimeEventsByLicenseIdStmt::prepareStmt() :: SELECT userintid, when, refid FROM UserFirstTimeEvents WHERE licenseId=${licenseId}$
SELECT * FROM UserFirstTimeEvents 
WHERE licenseId=${licenseId}$ -- 131072
  and userintid=${userintid}$ -- 45526136;
;

-- getUserProperties( UINT32 userIntId, const vector<UINT32>& propTypes, vector<UserProperty>& userProps)
-- SelectUserPropsStmt
SELECT PROPERTYID, PROPERTYINT, PROPERTYSTR, PROPERTYWHEN FROM USERPROPERTIES WHERE USERINTID=${userintid}$ --AND PROPERTYID IN(33,53,129)  -- 132 ?
order by propertywhen
;

select u.userintid, u.FISCALCODE,u.FLAGS,u.FLAGS2,u.FLAGS3,u.PRIVILEGES,u.PRIVILEGES2,u.PRIVILEGES3
        ,case when bitand(u.flags2, 268435456) != 0 then 'YES' else 'NO' end as bannedByRegulator
from users u
where u.userintid=${userintid}$
;
-------------------------------------------------------------
-- originally implemented for PYR-89035
-- #DBA_REVIEWED #PYR-149055 by HaiweiY 2020.Build.10
with rmok as
(
        select ufte.userintid,
        when as whenrmok,
        u.mobile,
        u.fiscalcode,
        (select propertystr from userproperties where userintid = ufte.userintid and propertyid = 33 and propertyint = 1) as nationalid
        from userfirsttimeevents ufte
        join users u on ufte.userintid = u.userintid
        where ufte.licenseid = 131072 and ufte.when < '${ReportTime}$'
        and u.userintid=${userintid}$
)
-- select * from rmok
-- 45526136	2016-12-01 13:13:05	914986819	243928343	13052784
, nowClosedWithReason as
(
        select r.userintid, 
        whenrmok,
        u.mobile,
        u.fiscalcode,
        (select propertystr from userproperties where userintid = u.userintid and propertyid = 33 and propertyint = 1) as nationalid,
        propertyint as closure_reason,
        propertywhen as whenclosed 
        from users u
        join rmok r on r.userintid = u.userintid
        join userproperties p on u.userintid = p.userintid
        where bitand(u.flags, 32) != 0 -- CLOSED
        and p.propertyid = 6
)
--no row - select * from nowClosedWithReason
,ptse as
(
        select s.*, row_number() over (partition by s.userintid order by excludedid) rn
        from rmok u
        join selfexcluded s on u.userintid = s.userintid and s.timefrom > whenrmok
)
-- no row - select * from ptse
, rs as --needed to choose the most recent status when player has multiple statuses among suspended, self-excluded or banned 
        -- statuses are divided into 3 groups (by priorities): closed(10), suspended/reactivated(20) and new accounts(30)
(
-- start priority 10
-- closed statuses
select c.userintid,
	case 
		when exists (select 1 from rmok r where (r.mobile = c.mobile or r.fiscalcode = c.fiscalcode or r.nationalid = c.nationalid) and r.whenrmok > c.whenrmok) then 0 -- ePtPlayerStatus_Undefined (will be excluded from report)
		when propertyint in (8,13) then 20 -- ePtPlayerStatus_AccountClosedReqOrIdChange
		when propertyint = 17 then 21 -- ePtPlayerStatus_AccountClosedGamblingIssue
		when propertyint = 69 then 19 -- ePtPlayerStatus_AccountClosedDormant 
		when propertyint = 52 then 5 -- ePtPlayerStatus_AccountClosedDeactivated 
		when propertyint = 60 then 6 -- ePtPlayerStatus_AccountClosedDeceased
	end	as status,
	p.propertywhen as statuschanged,
	0 as duration,
	10 as priority 
from nowClosedWithReason c
join userproperties p on p.userintid = c.userintid and p.propertyid = 6 and p.propertywhen > whenrmok and p.propertywhen < '${ReportTime}$'
and p.propertyint in (8,13,17,69,52,60)


union all
-- start priority 20
-- dormant set
        select u.userintid,
                8 as status, -- ePtPlayerStatus_BBRSuspendedDormantSet
                p.propertywhen as statuschanged,
                0 as duration,
                20 as priority 	
        from  users u 
        join rmok r on r.userintid = u.userintid
        join userproperties p on p.userintid = r.userintid and propertyid = 129 and bitand(propertyint,2) != 0 
        where bitand(u.flags2, 268435456) != 0 -- bannedByRegulator
        and p.propertywhen > whenrmok
        and p.propertywhen < '${ReportTime}$' 



union all
-- under investigation set
        select u.userintid,
                11 as status, -- ePtPlayerStatus_BBRSuspendedUnderInvestigSet
                p.propertywhen as statuschanged,
                0 as duration,
                20 as priority 	   
        from users u 
        join rmok r on r.userintid = u.userintid
        join userproperties p on p.userintid = u.userintid and p.propertyid = 132 and p.propertyint = 1
        and exists(select 1 from userproperties where userintid = u.userintid and propertyid = 129 and bitand(propertyint,24) != 0)
        where bitand(u.flags2, 268435456) != 0 -- bannedByRegulator
        and p.propertywhen > whenrmok
        and p.propertywhen < '${ReportTime}$' 



union all
-- suspended by compliance set
        select u.userintid,
                13 as status, -- ePtPlayerStatus_BBRSuspendedByComplianceSet
                p.propertywhen as statuschanged,
                0 as duration,
                20 as priority	   
        from users u 
        join rmok r on r.userintid = u.userintid
        join userproperties p on p.userintid = u.userintid and propertyid = 132 and propertyint = 2
        and exists(select 1 from userproperties where userintid = u.userintid and propertyid = 129 and bitand(propertyint,24) != 0)
        where bitand(u.flags2, 268435456) != 0 -- bannedByRegulator
        and p.propertywhen > whenrmok
        and p.propertywhen < '${ReportTime}$' 



union all
        select se.userintid,
                15 as status,-- ePtPlayerStatus_SeStartedShort
                timefrom as statuschanged,
                daysrequested as duration,
                20 as priority
        from ptse se
        where se.status in (0,4)
        and se.daysrequested != 0
        and se.daysrequested < 90
        and se.timefrom < '${ReportTime}$'
        and bitand(se.flags,32) = 0 --!ePtRevocationSelfExcluded



union all
-- dormant removed
        select r.userintid,
               9 as status, -- ePtPlayerStatus_BBRSuspendedDormantRemoved
               p.whenchanged as statuschanged,
               0 as duration,
               20 as priority                 
        from users u
        join rmok r on u.userintid = r.userintid
        join userpropaudit p on r.userintid = p.userintid and p.propertyid = 129 
        and 
        (
        bitand(p.propertyint,2) != 0 and action = 2  -- eUserPropertyActionDelete
          or
        (bitand(p.propertyint,2) = 0 and action = 1  -- eUserPropertyActionUpdate
         and value((select bitand(propertyint,2) 
                    from userpropaudit where userintid=r.userintid and propertyid=129 and whenchanged < p.whenchanged 
                    order by whenchanged desc fetch first 1 row only),0) != 0 
        )
        )
        and bitand(u.flags2, 268435456) = 0 -- !bannedByRegulator (be consistent with daily report)
        and p.whenchanged > whenrmok
        and p.whenchanged >= '${PTmidnight}$' 
        and p.whenchanged < '${ReportTime}$'



union all
-- under investigation removed
        select r.userintid,
                12 as status, -- ePtPlayerStatus_BBRSuspendedUnderInvestigRemoved
                p.whenchanged as statuschanged,
                0 as duration,
                20 as priority 	   
        from rmok r
        join userpropaudit p on p.userintid = r.userintid and propertyid = 132 and propertyint = 1 and action = 2 -- eUserPropertyActionDelete
        and exists (select 1 from userpropaudit p1 where
        (
        bitand(p1.propertyint,24) != 0 and action = 2  -- eUserPropertyActionDelete
          or
        (bitand(p1.propertyint,24) = 0 and action = 1  -- eUserPropertyActionUpdate
         and value((select bitand(p1.propertyint,24) 
                    from userpropaudit where userintid=r.userintid and propertyid = 129 and whenchanged < p1.whenchanged 
                    order by whenchanged desc fetch first 1 row only),0) != 0 
        )
        )
        )
        -- bannedByRegulator can still be ON
        and p.whenchanged > whenrmok
        and p.whenchanged >= '${PTmidnight}$' 
        and p.whenchanged < '${ReportTime}$'



union all
-- suspended by compliance removed
        select r.userintid,
                14 as status, -- ePtPlayerStatus_BBRSuspendedByComplianceRemoved
                p.whenchanged as statuschanged,
                0 as duration,
                20 as priority 	   	   
        from rmok r
        join userpropaudit p on p.userintid = r.userintid and propertyid = 132 and propertyint = 2 and action = 2 -- eUserPropertyActionDelete
        and exists (select 1 from userpropaudit p1 where
        (
        bitand(p1.propertyint,24) != 0 and action = 2  -- eUserPropertyActionDelete  
          or
        (bitand(p1.propertyint,24) = 0 and action = 1  -- eUserPropertyActionUpdate 
         and value((select bitand(p1.propertyint,24) 
                    from userpropaudit where userintid=r.userintid and propertyid = 129 and whenchanged < p1.whenchanged 
                    order by whenchanged desc fetch first 1 row only),0) != 0 
        )
        )
        )
        -- bannedByRegulator can still be ON
        and whenchanged > whenrmok
        and whenchanged >= '${PTmidnight}$' 
        and whenchanged < '${ReportTime}$'



union all
        select se.userintid,
                16 as status,-- ePtPlayerStatus_SeEndedShort
                sea.wheninvalidated,
                0 as duration,
                20 as priority
        from ptse se
        join selfexcludedaudit sea on se.excludedid = sea.excludedid 
        where se.status in (1,3)
        and sea.status in (0,4)
        and se.daysrequested != 0 and se.daysrequested < 90
        and sea.wheninvalidated >= '${PTmidnight}$' 
        and sea.wheninvalidated < '${ReportTime}$'
        and bitand(se.flags,32) = 0 --!ePtRevocationSelfExcluded



union all
        select se.userintid,
                17 as status,-- ePtPlayerStatus_SeEndedLong
                sea.wheninvalidated as statuschanged,
                0 as duration,
                20 as priority
        from ptse se
        join selfexcludedaudit sea on se.excludedid = sea.excludedid 
        where se.status in (1,3)
        and sea.status in (0,4)
        and se.daysrequested >= 90
        and sea.wheninvalidated >= '${PTmidnight}$' 
        and sea.wheninvalidated < '${ReportTime}$' 
        and not exists (select 1 from ptse where bitand(flags,32) != 0 and userintid = se.userintid and rn = se.rn+1) --not followed by revocation



union all
-- Report end of revocation as endedlong
        select se.userintid,
               17 as status,-- ePtPlayerStatus_SeEndedLong
               sea.wheninvalidated as statuschanged,
               0 as duration,
               20 as priority
        from ptse se 
        join selfexcludedaudit sea on se.excludedid = sea.excludedid
        where se.status in (1,3)
        and sea.status in (0,4)
        and se.daysrequested != 0 and se.daysrequested < 90 
        and bitand(se.flags,32) != 0 -- ePtRevocationSelfExcluded
        and sea.wheninvalidated >= '${PTmidnight}$' 
        and sea.wheninvalidated < '${ReportTime}$'
        and exists (select 1 from ptse where userintid = se.userintid and status in (1,3) and daysrequested >= 90 and rn = se.rn-1) --appears before revocation



union all
-- start priority 30
-- new account statuses
        select userintid,
               status,
               whenrmok as statuschanged,
               0 as duration,
               30 as priority
        from ( 
            -- linked with closed accounts 
            select u.userintid,
                case 
                        when c.closure_reason in (8,13) then 23 -- ePtPlayerStatus_NewAccountLinkedToClosedReqOrIdChng
                        when c.closure_reason = 17 then 26 -- ePtPlayerStatus_NewAccountLinkedToClosedGamblingIssue
                        when c.closure_reason = 69 then 24 -- ePtPlayerStatus_NewAccountLinkedToClosedDormant 
                        when c.closure_reason = 52 then 25 -- ePtPlayerStatus_NewAccountLinkedToClosedDeactivated
                        when c.closure_reason = 68 then 22 -- ePtPlayerStatus_NewAccountLinkedToClosedIndefiniteSe
                        when c.closure_reason = 80 then 27 -- ePtPlayerStatus_NewAccountLinkedToPermBlacklisted
                end as status,
                r.whenrmok,
                row_number() over (partition by u.userintid order by c.whenclosed desc) rn	
            from rmok r, nowClosedWithReason c
            join users u on r.userintid = u.userintid
            left outer join userproperties p on u.userintid = p.userintid and p.propertyid = 33 and p.propertyint = 1
            where r.whenrmok >= '${PTmidnight}$' and r.whenrmok < '${ReportTime}$'
            and (u.mobile = c.mobile or u.fiscalcode = c.fiscalcode or p.propertystr = c.nationalid) 
            and c.closure_reason in (8,13,17,69,52,68,80)
           )
        where rn = 1 -- choose link to most recently closed account

)

,rsfinal as
(
        select rs.*, row_number() over (partition by userintid order by priority asc, statuschanged desc) rn
        from rs
)

select userintid, status, duration, statuschanged from rsfinal where rn = 1 
;


--- SelectRmokUserChangesForPeriodStmt --
SELECT
  UC.UPDATEID
 ,UC.UPDATEDFIELD
 ,UC.UPDATETYPE
 ,UC.USERINTID
 ,UC.ADMININTID
 ,UC.WHEN
 ,UC.OLDVALUE
 ,UC.NEWVALUE
 ,UC.APPLOGINID 
FROM USERCHANGES UC 
JOIN USERS U ON UC.USERINTID=U.USERINTID 
JOIN USERFIRSTTIMEEVENTS FTE ON UC.USERINTID=FTE.USERINTID AND U.LICENSEID=FTE.LICENSEID 
WHERE U.LICENSEID=131072 and UC.USERINTID=${userintid}$
 AND UC.WHEN >= FTE.WHEN
 AND UC.WHEN BETWEEN '${PTmidnight}$' and '${ReportTime}$'
 AND UC.UPDATEDFIELD IN (12,28,43,9,1,2,3,6,5,7,10,34,27)
ORDER BY UC.USERINTID,UC.WHEN,UC.UPDATEID
;


--- SelectRmokUserPropChangesForPeriodStmt --
WITH H AS 
(
 SELECT
  UPA.*
 ,(SELECT UPA2.WHENCHANGED
   FROM USERPROPAUDIT UPA2
   WHERE UPA2.USERINTID=FTE.USERINTID AND UPA2.PROPERTYID=UPA.PROPERTYID AND UPA2.WHENCHANGED<UPA.WHENCHANGED
   ORDER BY 1 DESC FETCH FIRST 1 ROWS ONLY
  ) AS PREV_WHENCHANGED
 FROM USERPROPAUDIT UPA
 JOIN USERS U ON UPA.USERINTID=U.USERINTID
 JOIN USERFIRSTTIMEEVENTS FTE ON UPA.USERINTID+0=FTE.USERINTID AND U.LICENSEID=FTE.LICENSEID
 WHERE U.LICENSEID=131072 and U.USERINTID=${userintid}$
   AND UPA.WHENCHANGED>=FTE.WHEN
   AND UPA.WHENCHANGED BETWEEN '${PTmidnight}$' and '${ReportTime}$'
   AND UPA.PROPERTYID IN (6,33,53,129,132)
) 
, H2 AS 
(
 SELECT
  H.*
 ,UPA.RECORDID     AS RECORDID_PREV
 ,UPA.ADMININTID   AS ADMININTID_PREV
 ,UPA.COMMENT      AS COMMENT_PREV
 ,UPA.PROPERTYINT  AS PROPERTYINT_PREV
 ,UPA.PROPERTYSTR  AS PROPERTYSTR_PREV
 ,UPA.PROPERTYWHEN AS PROPERTYWHEN_PREV
 ,UPA.ACTION       AS ACTION_PREV
 ,UPA.APPLOGINID   AS APPLOGINID_PREV
 ,UPA.WHENCHANGED  AS WHENCHANGED_PREV
 ,ROW_NUMBER() OVER(PARTITION BY H.USERINTID,H.PROPERTYID,UPA.WHENCHANGED ORDER BY UPA.RECORDID DESC) AS NUM
 FROM H LEFT JOIN USERPROPAUDIT UPA ON H.USERINTID=UPA.USERINTID AND H.PROPERTYID=UPA.PROPERTYID AND H.PREV_WHENCHANGED=UPA.WHENCHANGED
) 
SELECT
  RECORDID
 ,ADMININTID
 ,COMMENT
 ,USERINTID
 ,PROPERTYID
 ,PROPERTYINT
 ,PROPERTYSTR
 ,PROPERTYWHEN
 ,ACTION
 ,APPLOGINID
 ,WHENCHANGED
 ,RECORDID_PREV
 ,ADMININTID_PREV
 ,COMMENT_PREV
 ,PROPERTYINT_PREV
 ,PROPERTYSTR_PREV
 ,PROPERTYWHEN_PREV
 ,ACTION_PREV
 ,APPLOGINID_PREV
 ,WHENCHANGED_PREV 
FROM H2 
WHERE NUM=1 
ORDER BY USERINTID,WHENCHANGED,RECORDID
;
