-- 
-- DBM_Q_GET_PT_VER_STATUS_FOR_USERS.sql
-- db2 -vtf D:\Users\mingtungl\scripts\sql\PT\DBM_Q_GET_PT_VER_STATUS_FOR_USERS.sql -z D:\Users\mingtungl\out\DBM_Q_GET_PT_VER_STATUS_FOR_USERS.txt > null

-- select *	from PTIDENTITYRESULTS where userintid in (142116418)
with result_num as
(
	select userintid, psstatus, resultid, when, ROW_NUMBER() over (partition by userintid order by resultid desc) as rn
	from PTIDENTITYRESULTS
	where userintid in (142116418)
),
first_result as (
    select userintid,
    case when rn = 1 then psstatus else 0 end as psstatus,
    1 as cnt
    from result_num
)
select userintid, max(psstatus) psstatus, sum(cnt) as res_count
from first_result
group by userintid
;