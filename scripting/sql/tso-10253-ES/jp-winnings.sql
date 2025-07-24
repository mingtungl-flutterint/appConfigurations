-- winnings.sql
--
-- db2 -vtf D:\Users\mingtungl\sql\tso-10253-ES\jp-winnings.sql
--	-v: echoes the commands
--	-t: sets statement terminator to ';'
--	-f: tells the command line to load commands from file
--	-s: stops execution if errors occur
--	-e: displays SQLCODE or SQLSTATE

with jackpots as (
	select je.jpxcreqid,je.refxcreqid,je.refpstime,je.eventtype,je.amount2jpcur,je.poolvaluejpcur,je.jackpotid,g.gametypeid,g.varianttype
	from xcjackpotevents je
	join xcgames g on je.gameid=g.gameid
	where je.jackpotid=19010
	  and je.refpstime between timestamp('2021-11-30-18.00.00') - 1 minute and timestamp('2021-12-31-18.00.00') + 1 minute
	  and je.jpxctime  between timestamp('2021-11-30-18.00.00')            and timestamp('2021-12-31-18.00.00') - 1 microsecond
	order by je.jpxctime,je.poolvaluejpcur
)
, count as (
	select count(*) row_count from jackpots
)
, win as (
	select * from jackpots where eventtype in (11,13)
	-- jpxcreqid:  388112076603
	-- refxcreqid: 388112076599
	-- amt:		   218241000
	-- pool:       0
)
, next as (
	select * from jackpots where jpxcreqid > (select jpxcreqid from win) order by jpxcreqid fetch first 1 row only
)
, prev as (
	select * from jackpots where jpxcreqid < (select jpxcreqid from win) order by jpxcreqid desc fetch first 1 row only
)
select * from jackpots
--from win w, next n, prev p
fetch first 20 rows only
;
