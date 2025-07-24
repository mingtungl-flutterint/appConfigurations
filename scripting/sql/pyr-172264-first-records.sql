-- pyr-172264.sql
--
-- db2 -vtf y:\minhl\pyr-172264.sql
--	-v: echoes the commands
--	-t: sets statement terminator to ';'
--	-f: tells the command line to load commands from file
--	-s: stops execution if errors occur
--	-e: displays SQLCODE or SQLSTATE


-- select count(*) row_count
-- from xcjackpotevents je
-- join xcgames g on je.gameid=g.gameid
-- where je.jackpotid=23012
  -- and je.refpstime between timestamp('2021-04-30-18.00.00') - 1 minute
  -- and timestamp('2021-05-30-18.00.00') + 1 minute
  -- and je.jpxctime between timestamp('2021-04-30-18.00.00')
  -- and timestamp('2021-05-30-18.00.00') - 1 microsecond;


select je.jpxcreqid,je.refxcreqid,je.refpstime,je.eventtype,je.amount2jpcur,je.poolvaluejpcur,je.jackpotid,g.gametypeid,g.varianttype
from xcjackpotevents je
join xcgames g on je.gameid=g.gameid
where je.jackpotid=23012
  and je.refpstime between timestamp('2021-04-30-18.00.00') - 1 minute
  and timestamp('2021-05-31-18.00.00') + 1 minute
  and je.jpxctime between timestamp('2021-04-30-18.00.00')
  and timestamp('2021-05-31-18.00.00') - 1 microsecond
order by je.jpxctime,je.poolvaluejpcur
fetch first 20 rows only;

-- row count = 1245865
select je.jpxcreqid,je.refxcreqid,je.refpstime,je.eventtype,je.amount2jpcur,je.poolvaluejpcur,je.jackpotid,g.gametypeid,g.varianttype
from xcjackpotevents je
join xcgames g on je.gameid=g.gameid
where je.jackpotid=23012
  and je.refpstime between timestamp('2021-04-30-18.00.00') - 1 minute
  and timestamp('2021-05-31-18.00.00') + 1 minute
  and je.jpxctime between timestamp('2021-04-30-18.00.00')
  and timestamp('2021-05-31-18.00.00') - 1 microsecond
order by je.jpxctime,je.poolvaluejpcur
offset 1245850 row
fetch next 50 rows only
--fetch first 20 rows only
;