-- db2 -vtf C:\Users\mingtungl\sql\query.sql -z C:\Users\mingtungl\out\results.txt > null
-- SelectBgNonTournHandsStmt.sql : poker cash
with X as (
select h.utcheartbeat
	, u.userintid
	, u.userid
	, h.handid
	, h.finished
	, value(up.propertystr, '') gameonplayerid
	--, h.potchips -- stake
	--, cast(round((h.rakesize * h.potchips / h.potsize) as integer)
	--, h.potchips + h.delta -- winning
	, h.currency
	, value(a1.ipaddress, a2.ipaddress, a3.ipaddress, '') ipaddr
from hands_usersinhand h
join users u on u.userid=h.userid
left join userproperties up on up.userintid=u.userintid and propertyid=89
left join loggedoutapp a1 on a1.apploginid=h.apploginid
left join loggedinapp  a2 on a2.apploginid=h.apploginid
left join logindata    a3 on a3.userid=h.userid
where bitand(u.privileges, 128)=0
  and bitand(u.privileges2, 512+2305843009213693952)=0
  and h.finished between '2021-06-19 00:00:00' and '2021-07-21 23:59:59'
  and h.isplaymoney in(0,3)
  and h.potchips>0
  and h.licenseid=8192
  and bitand(h.licenseid, 8192)!=0
)
select utcheartbeat, userintid, userid, handid, finished, gameonplayerid, ipaddr
from X
--where gameonplayerid=9007247067
;