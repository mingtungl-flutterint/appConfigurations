-- pyr-172264-row-count.sql

select count(*) row_count
from xcjackpotevents je
join xcgames g on je.gameid=g.gameid
where je.jackpotid=23012
  and je.refpstime between timestamp('2021-04-30-18.00.00') - 1 minute
  and timestamp('2021-05-31-18.00.00') + 1 minute
  and je.jpxctime between timestamp('2021-04-30-18.00.00')
  and timestamp('2021-05-31-18.00.00') - 1 microsecond
;
