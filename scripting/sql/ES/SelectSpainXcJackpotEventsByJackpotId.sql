-- SelectSpainXcJackpotEventsByJackpotId.sql

-- SelectAllXcJpSettings
--SELECT JPKEY,JPREFNAME,NAME,RESET,PRATE, RRATE,GUARANTEED,CURRENCY,PLAYFORFUN,HOSTS,SITES,DISABLED,VENDORID,VENDORJPID,USERESETVALUE, MULTICURRENCY,CREATETIME, CLOSETIME, JPTYPE,JPGROUPID
--FROM XC_JPSETTINGS;

-- SelectSpainXcJackpotEventsByJackpotId
declare global temporary table session.jackpots (
	jpxcreqid	bigint not null,
	refxcreqid	bigint not null,
	amount		bigint not null,
	pool		bigint not null,
	eventtype 	smallint not null,
	refpstime	timestamp not null
)
with replace on commit preserve rows not logged;

insert into session.jackpots
select je.jpxcreqid,je.refxcreqid,je.amount2jpcur, je.poolvaluejpcur, je.eventtype, je.refpstime
from xcjackpotevents je
join xcgames g on je.gameid=g.gameid
where je.jackpotid=19010
  and je.refpstime between timestamp('2021-11-30-18.00.00') - 1 minute and timestamp('2021-12-31-18.00.00') + 1 minute
  and je.jpxctime  between timestamp('2021-11-30-18.00.00')            and timestamp('2021-12-31-18.00.00') - 1 microsecond
order by je.refpstime desc;

--select * from session.jackpots;
--select * from session.jackpots where eventtype in (1,11);
select sum(amount) as total_bets from session.jackpots where eventtype in (1,11);

--select * from session.jackpots where eventtype in (3,13);
select sum(amount) as payout from session.jackpots where eventtype in (3,13);

select pool as initial_pool from session.jackpots order by refpstime asc fetch first 1 row only;
select pool as final_pool from session.jackpots order by refpstime desc fetch first 1 row only;

drop table session.jackpots;