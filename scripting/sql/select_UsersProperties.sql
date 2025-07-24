-- user properties
/**
with T as (
select USERINTID,PROPERTYID,PROPERTYINT,PROPERTYSTR,PROPERTYWHEN,ROW_NUMBER() OVER (PARTITION by userintid ORDER BY propertywhen DESC) as row_num
from db2admin.userproperties
where userintid in (${uiids}$) -- (98904944,100184128,128732080,99976885,110923949,105012261,97628569)
 and PROPERTYID in (33,34) -- eUserPropertyDocumentInfo (33), eUserPropertyDocumentIssuingAuthority (34)
)
select USERINTID,PROPERTYID,PROPERTYINT,PROPERTYSTR,PROPERTYWHEN
from T
--where row_num=1
order by userintid, PROPERTYWHEN desc;
*/
--------------------------------------------
with UPA as (
select up.USERINTID,u.flags2, up.PROPERTYID,up.PROPERTYINT,up.PROPERTYSTR,up.PROPERTYWHEN,up.WHENCHANGED
--up.RECORDID,up.ADMININTID,
from db2admin.userpropaudit up
join db2admin.users u on u.userintid=up.userintid
where up.userintid=98904944 -- in (${uiids}$)
 and up.PROPERTYID in (33,34)
),
DocInfo as (
select *, ROW_NUMBER() OVER (PARTITION by userintid ORDER BY WHENCHANGED desc) as row_num
from UPA where propertyid=33 --and row_num=1
),
IssuingAuth as (
select *, ROW_NUMBER() OVER (PARTITION by userintid ORDER BY WHENCHANGED desc) as row_num
from UPA where propertyid=34
)
select * from DocInfo where row_num=1
union
select * from IssuingAuth where row_num=1
order by userintid --, recordid
--fetch first 1 row only
;