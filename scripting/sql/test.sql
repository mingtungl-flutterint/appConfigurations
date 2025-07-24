
--marketdbm
SELECT MOVEMENTID, USERINTID, HEARTBEAT, MOVEMENTTYPE, REFERENCEID, AMOUNT, TCHIPS, MOVEMENTTIME, TRANSTYPE, DBMID
from db2admin.PTMONEYMOVEMENTS
WHERE userintid in (63068639)
    and HEARTBEAT BETWEEN '2022-01-05-2.00.00' AND cast('2022-01-05-3.00.00' as TIMESTAMP) - 1 microsecond
order by MOVEMENTTIME asc
;

-- DBM (Compliance)
select u.USERINTID,u.USERID,u.FLAGS,u.FLAGS2,u.FLAGS3 --,u.PRIVILEGES,u.PRIVILEGES2,u.PRIVILEGES3
        ,u.chips,u.tchips,u.fpp,u.playchips
        ,upa.PROPERTYSTR,upa.PROPERTYWHEN,upa.ACTION,upa.WHENCHANGED
        ,ua.CURRENCY,ua.CHIPS,ua.OWEDCHIPS,ua.TCHIPS,ua.WCHIPS
from db2admin.users u
join userpropaudit upa on u.userintid=upa.userintid and upa.whenchanged<'2022-01-05-0.00.00'
join useraccounts ua on ua.userintid=u.userintid
where u.userintid=63068639 and bitand(u.flags,8)<>0
order by upa.propertywhen desc
;

select u.USERINTID,u.USERID,u.FLAGS,u.FLAGS2,u.FLAGS3,u.PRIVILEGES,u.PRIVILEGES2,u.PRIVILEGES3
        ,u.chips,u.tchips,u.fpp,u.playchips
from db2admin.users u
join userpropaudit upa on u.userintid=upa.userintid and upa.whenchanged<'2022-01-05-0.00.00'
--join useraccounts ua on ua.userintid=u.userintid
where u.userintid=63068639 and bitand(u.flags,8)<>0
;

select * from db2admin.userchipsdaily where userintid=63068639 and currency='EUR' and taken>='2022-01-04-0.00.00' AND taken<'2022-01-05-23.00.00' order by taken;

select * from db2admin.userproperties where userintid=133895843 order by propertywhen desc;

select USERINTID,PROPERTYID,PROPERTYINT,PROPERTYSTR,PROPERTYWHEN,ADMININTID,ACTION,RECORDID,WHENCHANGED,COMMENT
from db2admin.userpropaudit
where userintid=133895843
order by recordid desc
;

with temp as (
    select t.userintid,t.transtype,t.chips,t.tchips,t.when
    from db2admin.transacts t
    where (t.when >= '${startPeriod}$'
       and t.when < '${endPeriod}$'
       )
    and exists (select 1 from db2admin.USERFIRSTTIMEEVENTS fte where fte.userintid=t.userintid+0 and fte.licenseid=128 and fte.when<=t.when)
)
select userintid, transtype, sum(bigint(chips)), sum(abs(bigint(chips))), sum(bigint(tchips)), sum(abs(bigint(tchips))), count(*)
from temp group by userintid, transtype
;

with temp as (
    select t.userintid,t.transtype,t.chips,t.tchips,t.when
    from db2admin.transacts t
    where t.when between '${startMonth}$' and '${endMonth}$' and t.when < '${endPeriod}}$'
        and exists (select 1 from db2admin.USERFIRSTTIMEEVENTS fte where fte.userintid=t.userintid and fte.licenseid=128 and fte.when<=t.when)
    union all
    select t.userintid,t.transtype,t.chips,t.tchips,t.when
    from db2admin.transacts t
    where (t.when >= '${startPeriod}$' and t.when < '${startMonth}$')
        and exists (select 1 from db2admin.USERFIRSTTIMEEVENTS fte where fte.userintid=t.userintid+0 and fte.licenseid=128 and fte.when<=t.when)
)
select userintid, transtype, sum(bigint(chips)), sum(abs(bigint(chips))), sum(bigint(tchips)), sum(abs(bigint(tchips))), count(*) from temp group by userintid, transtype
;





