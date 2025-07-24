-- pyt-184385.sql
--

--Bonuses: (Admin credit, tticket award, conversion ticket to tchips - ?) - Message 4.4 should be sent with causaleMovimento = 5
--Admin credits = 4002,4003,4004,4005,4033,4400,4401,4402,4403
--Tickets: 3026,3060,3061,3062,3078,3082,5024,5031,5130,7130,7131,7132,7133,7134,7135,9023,9304,9322,9324,9327
--Cancellation: 4309
--Conversion: 7116,7117

select 	t.TRANSID, t.USERID, t.USERINTID, t.ADMININTID, t.WHEN, t.TRANSTYPE, t.OBJECTID, t.CHIPS, t.COMMENT, t.CURRENCY,
		p.PGADTRANSID, p.FLAGS, p.TRANSIDREPORTED, p.WHENREPORTED, p.BONUSPART, p.ERRCODE, p.XTRANSSTR, p.PGADMSG, p.PROPSTR
from db2admin.transacts t
inner join db2admin.PGADTRANSACTS p on t.transid=p.transid
where t.transtype in (4309,4002,4003,4004,4005,4033,4400,4401,4402,4403,3026,3060,3061,3062,3078,3082,5024,5031,5130,7130,7131,7132,7133,7134,7135,9023,9304,9322,9324,9327,7116,7117)
order by t.transtype
;


with temp as (
    select t.TRANSID, t.USERID, t.USERINTID, t.ADMININTID, t.WHEN, t.TRANSTYPE, t.OBJECTID, t.CHIPS, t.COMMENT, t.CURRENCY
        , row_number() over (partition by t.transtype order by t.when desc) rn
    from db2admin.transacts t
    where t.transtype in (7111,7112,7113,7114,7115,7116,7117,7118,7119,7120,7121,7122) -- t.transid in(10805972894,10806078871,10806597162,10806654687,10806654687)
)
select * from temp where rn=1
;

select t.TRANSID, t.USERID, t.USERINTID, t.ADMININTID, t.WHEN, t.TRANSTYPE, t.OBJECTID, t.CHIPS, t.COMMENT, t.CURRENCY--
from db2admin.transacts t
where t.transid in (297086032820)
;
