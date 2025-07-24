-- db2 -vtf C:\Users\mingtungl\sql\query.sql -z C:\Users\mingtungl\out\results.txt > null
-- tso-10253-calculations.sql

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
order by je.refpstime, je.poolvaluejpcur
;

select * from session.jackpots;

/*
with initbalance as (
	select pool initial_value from session.jackpots fetch first 1 row only
)
--, finalbalance as (
--	select pool final_value from session.jackpots offset 1245864 row fetch next 1 row only
--)
, contrib as (
	select sum(amount) contributions from session.jackpots where eventtype in (1,11) group by eventtype
)
, win as (
	select sum(amount) winnings from session.jackpots where eventtype in (3,13) group by eventtype
)
select c.contributions, w.winnings, ib.initial_value, fb.final_value
from contrib c, win w, initbalance ib, finalbalance fb
;
*/

-- irrelevent types
--select * from session.jackpots where eventtype not in (1,11,3,13);

-- payout
select * from session.jackpots where eventtype in (3,13);

-- record count
select count(*) as row_count from session.jackpots;

-- records around payout
--select * from session.jackpots where refpstime>='2021-12-20-20.00.00' fetch next 6 rows only;
--select * from session.jackpots where jpxcreqid>=388112076602 fetch next 6 rows only;

-- records around pool change
--select * from session.jackpots where refpstime>='2021-12-20-20.00.00' fetch next 6 rows only;
--select * from session.jackpots where jpxcreqid>=388112221730 fetch next 6 rows only;


drop table session.jackpots;