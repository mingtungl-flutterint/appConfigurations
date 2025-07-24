-- db2 -vtf C:\Users\mingtungl\sql\query.sql -z C:\Users\mingtungl\out\results.txt > null
-- TSO-7803.sql

with result_num as
(
	select userintid, psstatus, resultid, when, row_nunber() over (partition by userintid order by resultid desc) as rn
	from ptidentityresults
	where userintid in (105437353)
),
first_result as
(
	select userintid, case when rn=1 then psstatus else 0 end as psstatus, 1 as cnt
	from result_num
)
select userintid, max(psstatus) psstatus, sum(cnt) as res_count
from first_result
group by userintid;