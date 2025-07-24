-- userDailyBalance.sql

-- ${startMonth}$  = '2021-11-01-0.00.00'
-- ${endMonth}$    = '2021-11-30-23.59.59'
-- ${startPeriod}$ = '2022-06-18-19.00.01' <-- this is ET timestamp. PT time will be 2022-06-19-00.00.01
-- ${endPeriod}$   = '2022-06-19-19.00.00' <-- this is ET timestamp. PT time will be 2022-06-20-00.00.00

SELECT MIN(croptime) as taken FROM db2admin.DAEMONTIMELOG WHERE croptype = 149 AND croptime BETWEEN '${startPeriod}$' AND '${endPeriod}$' AND licenseid=131072;

select * from db2admin.userfirsttimeevents
where licenseid=131072 
  and userintid in (${userIntIds}$)
  --and when
;


-- users table
select USERID, USERINTID, LICENSEID, SITEID, CHIPS, COUNTRY, FIRSTDEPOSIT, DEFAULTCUR, OWEDCHIPS, PREV_USERID, REGISTERED	-- users table
from db2admin.users
where userintid in (${userIntIds}$)
;

-- Transact table
/*
select TRANSID,USERID,WHEN,TRANSTYPE,OBJECTID,CHIPS,FPP,CHIPSAFTER,COMMENT,USERINTID,ADMININTID,CURRENCY
from db2admin.transacts 
WHERE when between '${startPeriod}$' AND '${endPeriod}$'
  and currency = 'EUR'
  and userintid in (${userintIds}$)
ORDER BY when;

select sum(CHIPS) from db2admin.transacts WHERE when between '${startPeriod}$' AND '${endPeriod}$' and userintid in (${userintIds}$);
*/

select TRANSID, USERID, WHEN, TRANSTYPE, OBJECTID, CHIPS, CHIPSAFTER, USERINTID, ADMININTID, CURRENCY, COMMENT
from db2admin.transacts	--
where userintid in (${userIntIds}$) and when>='2022-03-13-00.00.00' and when<'2022-03-15-00.00.00'	--
	and transtype in(7111,7112,7113,7114,7115,7116,7117,7118,7119,7120,7121,7122,7123)
order by when asc;

-- SelectPortugalUserBalanceDailyFromUserAccountStmt
SELECT c.userintid, c.userid, c.chips, c.owedchips, c.chips - c.owedchips as amount, c.tchips, c.ttt, c.acceptedRoll, c.taken	-- SelectPortugalUserBalanceDailyFromUserAccountStmt
from db2admin.userchipsdaily c	--
WHERE c.currency='EUR' and c.userintid in (${userIntIds}$)	--
    and c.taken between '${startPeriod}$' and '${endPeriod}$'
order by c.taken desc
;

-- SelectPortugalUserBalanceDailyFromUserAccountStmt
SELECT c.userintid, c.userid, c.chips - c.owedchips as amount, c.tchips, c.ttt, c.acceptedRoll, c.taken
FROM db2admin.userchipsdaily c
-- join users because of currently 1 PROD user whose license was changed to 0
JOIN db2admin.users u ON (c.userintid=u.userintid AND u.licenseid=131072)
JOIN db2admin.userfirsttimeevents ufte ON (c.userintid+0=ufte.userintid AND ufte.licenseid=131072 AND ufte.when <= c.taken)
WHERE c.currency = 'EUR'
  and c.taken=(SELECT MIN(croptime) FROM db2admin.DAEMONTIMELOG WHERE croptype = 149 AND croptime BETWEEN '${startPeriod}$' AND '${endPeriod}$' AND licenseid=131072)
  and c.userintid in (${userIntIds}$)
;

-- SelectPortugalUserBalanceDailyFromMoneyOnTablesStmt
SELECT m.userintid, m.userid, m.amount,	-- SelectPortugalUserBalanceDailyFromMoneyOnTablesStmt
    0, -- tchips
    0, -- ttt
    0, -- userRolls
    m.taken
from db2admin.usrmoneyontables m	--
JOIN userfirsttimeevents ufte ON (ufte.userintid = m.userintid AND ufte.licenseid = 131072 AND ufte.when <= m.taken)	--
WHERE m.currency='EUR' and m.userintid in (${userIntIds}$)
    and m.taken between '${startPeriod}$' AND '${endPeriod}$'
order by m.taken desc
;

-- SelectPortugalUnfinishedXcGameStmt
SELECT USERINTID, unresolvedBet, reservedFunds, unresolvedIB, reservedIB	-- SelectPortugalUnfinishedXcGameStmt
from db2admin.MoneyInXcGames	--
WHERE LicenseId=131072 and currency='EUR' and userintid in (${userIntIds}$)	--
    and timetaken between '${startPeriod}$' AND '${endPeriod}$' 
order by timetaken desc
;

