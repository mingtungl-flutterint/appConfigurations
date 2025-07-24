-- db2 -vtf C:\Users\mingtungl\sql\SelectPtIdentityResultsStatusStmt.sql -z C:\Users\mingtungl\out\SelectPtIdentityResultsStatusStmt.txt > null

-- select *	from PTIDENTITYRESULTS where userintid in (91377848)
with result_num as
(
	select userintid, psstatus, resultid, when, ROW_NUMBER() over (partition by userintid order by resultid desc) as rn
	from PTIDENTITYRESULTS
	where userintid in (91377848)
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
