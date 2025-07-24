-- GetUserRmokTimestamp.sql
DECLARE GLOBAL TEMPORARY TABLE SESSION.rmok_users
(
    USERINTID	INTEGER NOT NULL
    ,when1stRmOk TIMESTAMP NOT NULL
)
WITH REPLACE ON COMMIT PRESERVE ROWS NOT LOGGED;

INSERT INTO SESSION.rmok_users
with rmok as
(
    select uc.userintid, uc.when,row_number() over(partition by uc.userintid order by uc.when asc) as rn
    from db2admin.userchanges uc
    join db2admin.users u on u.userintid=uc.userintid and u.licenseid=16
    where uc.updatedfield=12 and uc.updatetype=1 and bitand(db2admin.hex2bigint(uc.oldvalue), 8)=0 and bitand(db2admin.hex2bigint(uc.newvalue), 8)<>0  -- receive rmok flag
      and uc.when < (select when from db2admin.UserFirsttimeEvents where licenseid=16 order by when asc fetch first 1 row only)
)
select userintid, when from rmok where rn=1
union
select userintid, when
from db2admin.UserFirsttimeEvents 
where licenseid=16 
  and when < (select when from db2admin.UserFirsttimeEvents where licenseid=16 order by when asc fetch first 1 row only) --'${rmokWhen}$'
;

--select * from SESSION.rmok_users order by userintid;



DECLARE GLOBAL TEMPORARY TABLE SESSION.fund_sweep_tas
(
    USERINTID	INTEGER NOT NULL,
    CHIPS	INTEGER NOT NULL,
    CHIPSAFTER	INTEGER NOT NULL,
    CURRENCY	VARCHAR(3) NOT NULL,
    OBJECTID	BIGINT NOT NULL,
    TRANSID	BIGINT NOT NULL,
    TRANSTYPE	SMALLINT NOT NULL,
    WHEN	TIMESTAMP NOT NULL,
    COMMENT	VARCHAR(512) NOT NULL,
    BUDGETCODEID        INTEGER NOT NULL,
    --BUDGETCODE_WHEN     TIMESTAMP NOT NULL
)
WITH REPLACE ON COMMIT PRESERVE ROWS NOT LOGGED;

INSERT INTO SESSION.fund_sweep_tas
select ta.USERINTID, ta.CHIPS, ta.CHIPSAFTER, ta.CURRENCY, ta.OBJECTID,ta.TRANSID, ta.TRANSTYPE, ta.WHEN , ta.COMMENT, tb.BUDGETCODEID
from db2admin.transacts ta
join rmok_users u ON ta.userIntId=u.userIntId -- includes older accounts (pre USERFIRSTTIMEEVENTS)
join db2admin.transactbudgetcodes tb on tb.BUDGETCODEID=1674 and tb.TRANSACTID=ta.TRANSID
where ta.transtype in (4000) and ta.CHIPS<>0
  and ta.when BETWEEN '${transactStart}$' AND cast('${transactEnd}$' as TIMESTAMP) - 1 microsecond
;

drop TABLE SESSION.rmok_users;
drop TABLE SESSION.fund_sweep_tas;