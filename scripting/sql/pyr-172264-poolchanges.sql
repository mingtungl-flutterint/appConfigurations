-- poolchanges.sql

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
where je.jackpotid=23012
  and je.refpstime between timestamp('2021-04-30-18.00.00') - 1 minute
  and timestamp('2021-05-31-18.00.00') + 1 minute
  and je.jpxctime between timestamp('2021-04-30-18.00.00')
  and timestamp('2021-05-31-18.00.00') - 1 microsecond
--order by je.refxcreqid, je.refpstime, je.poolvaluejpcur
order by je.refpstime, je.poolvaluejpcur, je.refxcreqid
;

--select * from session.jackpots order by pool fetch first 20 rows only;
select * from session.jackpots
where refpstime >= '2021-05-21-09.36.52.000000' and refpstime < '2021-05-21-09.38.56.000000'
;

-- payout
--select * from session.jackpots where refpstime>='2021-05-21-09.38.49' fetch next 6 rows only;

-- pool change
--select * from session.jackpots where refpstime>='2021-05-21-09.36.52' fetch next 6 rows only;


--select * from session.jackpots where jpxcreqid>=388112221730 fetch next 6 rows only;
--select * from session.jackpots where jpxcreqid>=388112076602 fetch next 6 rows only;


drop table session.jackpots;