-- db2 -vtf C:\Users\mingtungl\sql\query.sql -z C:\Users\mingtungl\out\results.txt > null
-- pyr-172264-calculations.sql

with R as (
	select je.amount2jpcur amount, je.poolvaluejpcur pool, je.eventtype, je.jpxctime
	from xcjackpotevents je
	join xcgames g on je.gameid=g.gameid
	where je.jackpotid=23012
	  and je.refpstime between timestamp('2021-04-30-18.00.00') - 1 minute
	  and timestamp('2021-05-31-18.00.00') + 1 minute
	  and je.jpxctime between timestamp('2021-04-30-18.00.00')
	  and timestamp('2021-05-31-18.00.00') - 1 microsecond
	  --and je.eventtype in (1,11,3,13)
	order by je.jpxctime,je.poolvaluejpcur
)
, contrib as (
	select sum(amount) contributions
	from R
	where eventtype in (1,11)
	group by eventtype  
)
, win as (
	select sum(amount) winnings
	from R
	where eventtype in (3,13)
	group by eventtype  
)
select c.contributions, w.winnings
	, (select pool from R fetch first 1 row only) initial_value
	, (select pool from R offset 1245864 row fetch next 1 row only) final_value
from contrib c, win w
;