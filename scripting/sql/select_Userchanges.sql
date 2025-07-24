-- select-userchanges.sql
-- timestamp format: 2024-07-30 20:00:00


select USERINTID,ADMININTID,UPDATEID,UPDATEDFIELD,UPDATETYPE,WHEN,OLDVALUE,NEWVALUE
from db2admin.userchanges
where USERINTID in (${uiids}$)
--and UPDATEDFIELD in (12,18,35,43)
and UPDATEDFIELD in (1,3,5,6,7,10,11,12,18,21,25,26,33)
--and when >= '2021-11-01-00.00.00'
and when BETWEEN '2021-11-01 00:00:00' AND cast('2021-12-01 00:00:00' as TIMESTAMP) - 1 microsecond
--AND UPDATETYPE IN (1,6,7,8,9,21,22,25,28,32,33,36,37,38,40,55,57,70,78,107,108,111,41,43,44,45,235,237,249)
AND UPDATETYPE IN (1,8,28,40,41,55,57,70,107,108,111,235,249)
AND oldvalue <> newvalue
and ADMININTID = 0
order by updateid desc, when desc
with ur
;

--select * from tablelimits where USERINTID in (${uiid}$) and requested>'2024-1-16 00:00:00';

/*
-- UPDATE FIELDS
fieldPrivileges = 11
fieldPrivileges2 = 21,
fieldPrivileges3 = 42,
fieldFlags = 12,
fieldFlags2 = 28
fieldFlags3 = 43,
fieldFrSpendingLimit = 35

-- UPDATE TYPES
typeUserUpdatePriv = 28,
typeSelfExclusion = 43,
typeUserAdminAuthVerified = 57,
typeSetTournLimit = 83,
typeSentWelcomeEmail = 84,
typeUpdateFrSpendingLimitByUser = 85,
typeUpdateItAccVerification = 99,
typeSetSportsStakeLimit = 156,
typeChangeBanByPortugueseRegulatorFlag = 173,
typeChangeBanByItalianRegulatorFlag = 206,
*/

select userid,flags, flags2, flags3, privileges, privileges2, privileges3 from db2admin.users where userintid in (${uiids}$);

select RECORDID, ADMININTID, USERINTID, PROPERTYID, PROPERTYINT, PROPERTYSTR, PROPERTYWHEN, ACTION, WHENCHANGED, COMMENT
 from db2admin.userpropaudit where userintid in (${uiids}$)
 and whenchanged>'2024-01-11 00:00:00'
 --and whenchanged BETWEEN '2024-01-11 00:00:00' AND cast('2024-01-12 00:00:00' as TIMESTAMP) - 1 microsecond
order by recordid desc, whenchanged desc;

select COMMENTID,USERID,ADMINID,WHEN,USERINTID,ADMININTID,FLAGS,COMMENT
from db2admin.usercomments
where userintid in (${uiids}$)
 and when > '2024-01-11 00:00:00'
--and when BETWEEN '2024-01-11 00:00:00' AND cast('2024-01-12 00:00:00' as TIMESTAMP) - 1 microsecond
order by commentid desc, when desc
;

select USERID, USERINTID, ADDR_1, ADDR_2, CITY, COMMENTS, COUNTRY, FIRSTNAME, FISCALCODE, FULLNAME, INSTALLID, LASTNAME, LICENSEID, NAC2, REGISTERED, SECUREID, STATE, UNIQUE, ZIPCODE
from db2admin.users
where userintid in (${uiids}$) --(98904944)--,100184128,128732080,99976885,110923949,105012261,97628569)
;

with result_num as 
( 
select userintid, psstatus, resultid, when, ROW_NUMBER() over (partition by userintid order by resultid desc) as rn 
from PTIDENTITYRESULTS 
where userintid in (${uiids}$)
),
first_result as ( 
select userintid, 
case when rn = 1 then psstatus else 0 end as psstatus, 
1 as cnt 
from result_num 
) 
select userintid, max(psstatus) psstatus, sum(cnt) as res_count 
from first_result 
group by userintid;